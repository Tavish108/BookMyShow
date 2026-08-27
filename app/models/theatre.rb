class Theatre < ApplicationRecord
  has_many :auditoriums, dependent: :destroy
  STATUSES = %w[ACTIVE INACTIVE].freeze
  validates :name, presence: true
  validates :city, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
end
