class VerificationMailer < ApplicationMailer
  def otp
    @recipient = params[:recipient]
    @otp = params[:otp]
    @purpose = params[:purpose]

    mail(
      to: @recipient.email,
      subject: email_subject
    )
  end

  private

  def email_subject
    case @purpose
    when "EMAIL_VERIFICATION"
      "BookMyShow - Verify Your Email"
    when "PASSWORD_RESET"
      "BookMyShow - Password Reset OTP"
    else
      "BookMyShow - Verification OTP"
    end
  end
end