class Movie < ApplicationRecord
  belongs_to :language

  belongs_to :creator,
             class_name: "User",
             foreign_key: :created_by_id

  has_many :movie_genres, dependent: :destroy
  has_many :genres, through: :movie_genres

  has_many :shows, dependent: :destroy

  validates :title, presence: true
  validates :duration_minutes, presence: true, numericality: { greater_than: 0 }
  validates :release_date, presence: true
  validates :certificate, presence: true
  validates :status, presence: true
end