class Seat < ApplicationRecord
  belongs_to :auditorium

  validates :auditorium, presence: true
  validates :row_name, presence: true
  # validates :seat_number, presence: true, numericality: { greater_than: 0 }
  validates :seat_number,
              uniqueness: {
                scope: [ :auditorium_id, :row_name ]
              }
end
