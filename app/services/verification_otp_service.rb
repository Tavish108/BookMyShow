class VerificationOtpService
  OTP_LENGTH = 6
  OTP_EXPIRY = 10.minutes
  MAX_ATTEMPTS = 5

  def self.generate(user: nil, pending_registration: nil, purpose:)
    new(
      user: user,
      pending_registration: pending_registration,
      purpose: purpose
    ).generate
  end

  def self.verify(user: nil, pending_registration: nil, purpose:, otp:)
    new(
      user: user,
      pending_registration: pending_registration,
      purpose: purpose
    ).verify(otp)
  end

  def initialize(user: nil, pending_registration: nil, purpose:)
    @user = user
    @pending_registration = pending_registration
    @purpose = purpose
  end

  def generate
    validate_purpose!

    verification_otps
      .where(purpose: @purpose, verified_at: nil)
      .update_all(verified_at: Time.current)

    otp = SecureRandom.random_number(1_000_000)
                          .to_s
                          .rjust(OTP_LENGTH, "0")

    verification_otp = verification_otps.create!(
      otp_digest: BCrypt::Password.create(otp),
      purpose: @purpose,
      expires_at: OTP_EXPIRY.from_now
    )

    {
      verification_otp: verification_otp,
      otp: otp
    }
  end

  def verify(otp)
    validate_purpose!

    verification_otp = verification_otps
                         .where(
                           purpose: @purpose,
                           verified_at: nil
                         )
                         .order(created_at: :desc)
                         .first

    return failure("OTP not found") unless verification_otp
    return failure("OTP has expired") if verification_otp.expired?
    return failure("Maximum attempts exceeded") if verification_otp.attempts >= MAX_ATTEMPTS

    verification_otp.increment!(:attempts)

    unless BCrypt::Password.new(verification_otp.otp_digest) == otp.to_s
      return failure("Invalid OTP")
    end

    verification_otp.update!(verified_at: Time.current)

    {
      success: true,
      message: "OTP verified successfully."
    }
  end

  private

  def verification_otps
    if @pending_registration
      @pending_registration.verification_otps
    elsif @user
      @user.verification_otps
    else
      raise ArgumentError, "User or PendingRegistration is required"
    end
  end

  def validate_purpose!
    return if VerificationOtp::PURPOSES.include?(@purpose)

    raise ArgumentError, "Invalid OTP purpose"
  end

  def failure(message)
    {
      success: false,
      message: message
    }
  end
end
