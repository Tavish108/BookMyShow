class VerificationOtp < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :pending_registration, optional: true

  PURPOSES = %w[
    EMAIL_VERIFICATION
    PHONE_VERIFICATION
    PASSWORD_RESET
  ].freeze

  validates :otp_digest, presence: true
  validates :purpose, presence: true, inclusion: { in: PURPOSES }
  validates :expires_at, presence: true
  validates :attempts, numericality: { greater_than_or_equal_to: 0 }

  def expired?
    expires_at <= Time.current
  end

  def verified?
    verified_at.present?
  end
end