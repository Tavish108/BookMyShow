class PendingRegistration < ApplicationRecord
  has_many :verification_otps, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true
  validates :phone, presence: true
  validates :password_digest, presence: true
  validates :expires_at, presence: true

  def expired?
    expires_at <= Time.current
  end
end