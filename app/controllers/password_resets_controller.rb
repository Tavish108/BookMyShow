class PasswordResetsController < ApplicationController
  def new
  end

  def create
    login_input = params[:email].to_s.strip

    @user = if login_input.include?("@")
              User.find_by(email: login_input.downcase)
            else
              User.find_by(phone: login_input)
            end

    unless @user
      flash.now[:alert] = "No account found with that email or mobile number."
      render :new, status: :unprocessable_entity
      return
    end

    result = VerificationOtpService.generate(
      user: @user,
      purpose: "PASSWORD_RESET"
    )

Rails.logger.info "PASSWORD RESET OTP: #{result[:otp]}"

VerificationMailer.with(
  recipient: @user,
  otp: result[:otp],
  purpose: "PASSWORD_RESET"
).otp.deliver_now


    session[:password_reset_user_id] = @user.id

    # Temporary: show OTP in development.
    # Later this will be sent by email/SMS.
    session[:password_reset_otp] = result[:otp]

    redirect_to verify_password_reset_path,
                notice: "OTP has been generated. Please verify it."
  end

  def verify
    unless password_reset_user
      redirect_to forgot_password_path,
                  alert: "Please request a password reset first."
    end
  end

  def verify_otp
    user = password_reset_user

    unless user
      redirect_to forgot_password_path,
                  alert: "Please request a password reset first."
      return
    end

    result = VerificationOtpService.verify(
      user: user,
      purpose: "PASSWORD_RESET",
      otp: params[:otp]
    )

    if result[:success]
      session[:password_reset_verified] = true

      redirect_to reset_password_path
    else
      flash.now[:alert] = result[:message]
      render :verify, status: :unprocessable_entity
    end
  end

  def edit
    unless password_reset_verified?
      redirect_to forgot_password_path,
                  alert: "Please verify your OTP first."
    end
  end

  def update
    unless password_reset_verified?
      redirect_to forgot_password_path,
                  alert: "Please verify your OTP first."
      return
    end

    user = password_reset_user

    if params[:password].blank?
      flash.now[:alert] = "Password cannot be blank."
      render :edit, status: :unprocessable_entity
      return
    end

    if params[:password] != params[:password_confirmation]
      flash.now[:alert] = "Passwords do not match."
      render :edit, status: :unprocessable_entity
      return
    end

    if user.update(
      password: params[:password],
      password_confirmation: params[:password_confirmation]
    )
      session.delete(:password_reset_user_id)
      session.delete(:password_reset_verified)
      session.delete(:password_reset_otp)

      redirect_to login_path,
                  notice: "Password reset successfully. Please login."
    else
      flash.now[:alert] = user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def password_reset_user
    @password_reset_user ||= User.find_by(
      id: session[:password_reset_user_id]
    )
  end

  def password_reset_verified?
    password_reset_user.present? &&
      session[:password_reset_verified] == true
  end
end