class Show < ApplicationRecord
  belongs_to :movie
  belongs_to :theatre
  belongs_to :auditorium
  has_many :show_seats, dependent: :destroy
end