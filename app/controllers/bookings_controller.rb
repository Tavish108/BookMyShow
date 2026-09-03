class BookingsController < ApplicationController
  before_action :require_login

  before_action :set_show,
                only: [:new, :create]

  before_action :set_booking,
                only: [:show]


  # GET /shows/:show_id/book
  def new
    
  ensure_show_seats

  @movie = @show.movie

  @show_seats = @show.show_seats       #query optimised by sorting in postgress table itself
                     .joins(:seat)
                     .includes(:seat)
                     .order("seats.row_name ASC, seats.seat_number ASC")
  end


  # POST /shows/:show_id/book
  def create
    ensure_show_seats

    seat_ids = Array(params[:show_seat_ids]).reject(&:blank?)


    if seat_ids.blank?

      redirect_to new_booking_path(show_id: @show.id),
                  alert: "Please select at least one seat."

      return
    end


    begin

      @booking = create_booking_with_hold(seat_ids)

      redirect_to booking_path(@booking),
                  notice: "Seats held for 5 minutes."

    rescue StandardError => e

      redirect_to new_booking_path(show_id: @show.id),
                  alert: e.message

    end
  end


  # GET /bookings/:id
  def show
  end


  private


  # Find the show
  def set_show

    @show = Show
      .includes(
        :movie,
        :theatre,
        :auditorium
      )
      .find(params[:show_id])

  end


  # Find current user's booking
  def set_booking

    @booking = current_user.bookings
      .includes(
        :show,
        :payment,
        booking_seats: {
          show_seat: :seat
        }
      )
      .find(params[:id])

  end


  # Create ShowSeat records for every
  # seat in the auditorium if they don't exist.
  def ensure_show_seats

    @show.auditorium.seats.find_each do |seat|

      ShowSeat.find_or_create_by!(
        show: @show,
        seat: seat
      ) do |show_seat|

        show_seat.status = "AVAILABLE"

      end

    end

  end


  # Create booking and hold seats
def create_booking_with_hold(seat_ids)
  Booking.transaction do

    seat_ids = Array(seat_ids).map(&:to_i).uniq

    show_seats = ShowSeat
      .where(
        show_id: @show.id,
        id: seat_ids
      )
      .lock
      .includes(:seat)

    if show_seats.length != seat_ids.length
      raise StandardError, "Invalid seat selection."
    end

    unavailable = show_seats.reject(&:available?)

    if unavailable.any?
      labels = unavailable.map do |show_seat|
        "#{show_seat.seat.row_name}#{show_seat.seat.seat_number}"
      end

      raise StandardError,
            "These seats are no longer available: #{labels.join(', ')}"
    end

    total = show_seats.length * @show.price

    booking = current_user.bookings.create!(
      show: @show,
      status: "PENDING",
      total_amount: total,
      expires_at: 5.minutes.from_now
    )

    show_seats.each do |show_seat|
      show_seat.update!(
        status: "HELD",
        held_until: booking.expires_at
      )

      booking.booking_seats.create!(
        show_seat: show_seat,
        price: @show.price
      )
    end

    booking.create_payment!(
      status: "PENDING",
      amount: total
    )

    booking
  end
end

end