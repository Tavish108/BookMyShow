class Theatre < ApplicationRecord
  belongs_to :creator, class_name: "User", foreign_key: :created_by_id
  has_many :auditoriums, dependent: :destroy
  STATUSES = %w[ACTIVE INACTIVE].freeze
  validates :name, presence: true
  validates :city, presence: true
  validates :status, presence: true, inclusion: { in: STATUSES }
end
