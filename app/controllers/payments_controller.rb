class PaymentsController < ApplicationController
  before_action :require_login
  before_action :set_booking

  def new
    @payment = @booking.payment
  end

  def create
    @payment = @booking.payment

    if @booking.expires_at.present? && @booking.expires_at <= Time.current
      expire_booking

      redirect_to booking_path(@booking),
                  alert: "Your seat hold has expired. Please select seats again."
      return
    end

    if @booking.status != "PENDING"
      redirect_to booking_path(@booking),
                  alert: "This booking cannot be paid."
      return
    end

    Booking.transaction do
      @booking.lock!

      @booking.booking_seats.includes(:show_seat).each do |booking_seat|
        show_seat = booking_seat.show_seat

        show_seat.update!(
          status: "BOOKED",
          held_until: nil
        )
      end

      @payment.update!(
        status: "SUCCESS",
        paid_at: Time.current
      )

      @booking.update!(
        status: "CONFIRMED",
        expires_at: nil
      )
    end

    redirect_to booking_path(@booking),
                notice: "Payment successful. Your booking is confirmed."
  rescue ActiveRecord::RecordInvalid => e
    redirect_to new_booking_payment_path(@booking),
                alert: e.message
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