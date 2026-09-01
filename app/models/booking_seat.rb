class BookingSeat < ApplicationRecord
  belongs_to :booking
  belongs_to :show_seat

  validates :price,
            numericality: { greater_than: 0 }
end