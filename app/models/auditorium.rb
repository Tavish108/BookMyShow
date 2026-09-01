class Auditorium < ApplicationRecord
  belongs_to :theatre
  has_many :seats, dependent: :destroy
  has_many :shows, dependent: :destroy
  validates :theatre, presence: true
  validates :name, presence: true
  validates :capacity, presence: true, numericality: { greater_than: 0 }
end
