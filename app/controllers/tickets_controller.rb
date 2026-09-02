class TicketsController < ApplicationController
  before_action :require_login
  before_action :set_ticket

  def show
  end

  private

  def set_ticket
    @ticket = Ticket.joins(:booking)
              .where(bookings: { user_id: current_user.id })
              .includes(
                booking: [
                  :payment,
                  {
                    show: [:movie, :theatre, :auditorium],
                    booking_seats: { show_seat: :seat }
                  }
                ]
              ).find(params[:id])
  end
end
