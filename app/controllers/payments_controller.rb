class PaymentsController < ApplicationController
  before_action :require_login
  before_action :set_booking

  def new
    @payment = @booking.payment

    if @payment.nil?
      redirect_to booking_path(@booking),
                  alert: "Payment record not found."
      return
    end

    if @booking.status != "PENDING"
      redirect_to booking_path(@booking),
                  alert: "This booking cannot be paid."
      return
    end

    if @booking.expired?
      expire_booking

      redirect_to booking_path(@booking),
                  alert: "Your seat hold has expired. Please select the seats again."
      return
    end

    create_razorpay_order
  end

  def create
    Rails.logger.info(
      "RAZORPAY PARAMS: #{params.to_unsafe_h.slice(
        "razorpay_payment_id",
        "razorpay_order_id",
        "razorpay_signature"
      )}"
    )

    @payment = @booking.payment

    if @payment.nil?
      redirect_to booking_path(@booking),
                  alert: "Payment record not found."
      return
    end

    if @booking.status != "PENDING"
      redirect_to booking_path(@booking),
                  alert: "This booking cannot be paid."
      return
    end

    razorpay_payment_id = params[:razorpay_payment_id]
    razorpay_order_id = params[:razorpay_order_id]
    razorpay_signature = params[:razorpay_signature]

    if razorpay_payment_id.blank? ||
       razorpay_order_id.blank? ||
       razorpay_signature.blank?

      @payment.update!(status: "FAILED")

      redirect_to booking_path(@booking),
                  alert: "Payment information was incomplete."
      return
    end

    # The order returned by Razorpay must match
    # the order created and stored by our server.
    unless razorpay_order_id == @payment.razorpay_order_id
      @payment.update!(status: "FAILED")

      redirect_to booking_path(@booking),
                  alert: "Invalid payment order."
      return
    end

    # Verify Razorpay signature BEFORE confirming anything.
    verify_razorpay_signature(
      razorpay_payment_id,
      @payment.razorpay_order_id,
      razorpay_signature
    )

    # The payment is authentic at this point.
    #
    # Now check whether the booking hold is still valid.
    if @booking.expired?
      expire_booking

      redirect_to booking_path(@booking),
                  alert: "Your seat hold expired before payment could be confirmed."
      return
    end

    Booking.transaction do
      @booking.lock!
      @payment.lock!

      if @booking.status != "PENDING"
        raise StandardError, "This booking has already been processed."
      end

      @booking.booking_seats.includes(:show_seat).each do |booking_seat|
        show_seat = booking_seat.show_seat

        show_seat.update!(
          status: "BOOKED",
          held_until: nil
        )
      end

      @payment.update!(
        status: "SUCCESS",
        transaction_id: razorpay_payment_id,
        razorpay_order_id: razorpay_order_id,
        razorpay_signature: razorpay_signature,
        paid_at: Time.current
      )

      @booking.update!(
        status: "CONFIRMED",
        expires_at: nil
      )
    end

    redirect_to booking_path(@booking),
                notice: "Payment successful. Your booking is confirmed."

  rescue Razorpay::Error => e
    Rails.logger.error(
      "RAZORPAY ERROR: #{e.class} - #{e.message}"
    )

    @payment.update!(status: "FAILED") if @payment.present?

    redirect_to booking_path(@booking),
                alert: "Payment verification failed."

  rescue StandardError => e
    Rails.logger.error(
      "PAYMENT ERROR: #{e.class} - #{e.message}"
    )

    Rails.logger.error(
      e.backtrace.first(10).join("\n")
    )

    redirect_to booking_path(@booking),
                alert: "Payment processing failed: #{e.message}"
  end

  private

  def set_booking
    @booking = current_user.bookings
                           .includes(
                             :show,
                             :payment,
                             booking_seats: {
                               show_seat: :seat
                             }
                           )
                           .find(params[:booking_id])
  end

  def create_razorpay_order
    amount_in_paise = (@payment.amount.to_d * 100).to_i

    order = Razorpay::Order.create(
      amount: amount_in_paise,
      currency: "INR",
      receipt: "booking_#{@booking.id}"
    )

    @payment.update!(
      razorpay_order_id: order.id,
      status: "PENDING"
    )

    @razorpay_order = order

  rescue Razorpay::Error => e
    Rails.logger.error(
      "RAZORPAY ORDER ERROR: #{e.class} - #{e.message}"
    )

    redirect_to booking_path(@booking),
                alert: "Unable to start payment. Please try again."
  end

  def verify_razorpay_signature(payment_id, order_id, signature)
    Razorpay::Utility.verify_payment_signature(
      {
        razorpay_payment_id: payment_id,
        razorpay_order_id: order_id,
        razorpay_signature: signature
      }
    )
  end

  def expire_booking
    Booking.transaction do
      @booking.booking_seats.includes(:show_seat).each do |booking_seat|
        show_seat = booking_seat.show_seat

        show_seat.update!(
          status: "AVAILABLE",
          held_until: nil
        )
      end

      @booking.update!(
        status: "EXPIRED"
      )

      @booking.payment&.update!(
        status: "FAILED"
      )
    end
  end
end
