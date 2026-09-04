class Ticket < ApplicationRecord
  belongs_to :booking

  validates :ticket_number, presence: true, uniqueness: true
  validates :qr_token, presence: true, uniqueness: true
end
