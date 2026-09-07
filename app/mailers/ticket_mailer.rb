class TicketMailer < ApplicationMailer
  def booking_confirmation(ticket)
        @ticket = ticket
        @booking = ticket.booking
        @user  = @booking.user
        @seats = @booking.booking_seats.includes(show_seat: :seat)

        mail(
          to: @user.email,
          subject: "Your ticket is Confirmed"
        )
  end
end