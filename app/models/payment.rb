class Payment < ApplicationRecord
  belongs_to :booking

  STATUSES = %w[PENDING SUCCESS FAILED REFUNDED].freeze

  validates :status,
            presence: true,
            inclusion: { in: STATUSES }

  validates :amount,
            numericality: { greater_than: 0 }
end
