class Ticket < ApplicationRecord
  belongs_to :booking

  after_commit :send_ticket_email, on: :create


  validates :ticket_number, presence: true, uniqueness: true
  validates :qr_token, presence: true, uniqueness: true


  private

  def send_ticket_email
    TicketMailer.booking_confirmation(self).deliver_later
  end
end
