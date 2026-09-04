class Booking < ApplicationRecord
  belongs_to :user
  belongs_to :show

  has_many :booking_seats, dependent: :destroy
  has_many :show_seats, through: :booking_seats

  has_one :payment, dependent: :destroy
  has_one :ticket, dependent: :destroy

  STATUSES = %w[PENDING CONFIRMED EXPIRED CANCELLED FAILED REFUNDED].freeze

  validates :status,
            presence: true,
            inclusion: { in: STATUSES }

  validates :total_amount,
            numericality: { greater_than_or_equal_to: 0 }

  def expired?
    expires_at.present? && expires_at <= Time.current
  end

  def active_hold?
    status == "PENDING" &&
      expires_at.present? &&
      expires_at > Time.current
  end
end
