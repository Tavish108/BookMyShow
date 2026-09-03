class UsersController < ApplicationController

  def new
    redirect_to dashboard_path_for_current_user if logged_in?

    @user = User.new
  end

  def create
    @user = User.new(user_params)

    # Validate registration data without saving User
    unless @user.valid?
      render :new, status: :unprocessable_entity
      return
    end

    # Do not allow registration if an account already exists
    if User.exists?(email: @user.email.downcase)
      flash.now[:alert] = "An account with this email already exists. Please login."
      render :new, status: :unprocessable_entity
      return
    end

    # Find existing pending registration or create a new one   find or initatialize
    @pending_registration = PendingRegistration.find_or_initialize_by(
      email: @user.email.downcase
    )

    @pending_registration.assign_attributes(
      name: @user.name,
      phone: @user.phone,
      password_digest: @user.password_digest,
      expires_at: 30.minutes.from_now
    )

    @pending_registration.save!

    session[:pending_registration_id] = @pending_registration.id

    # Generate and send fresh email OTP
    generate_verification_otps

    redirect_to verify_registration_path,
                notice: "Account created. Please verify your email."
  end

  def me
    unless logged_in?
      redirect_to login_path, alert: "Please log in first."
      return
    end
  end

  def verify_registration
    @pending_registration =
      PendingRegistration.find_by(id: session[:pending_registration_id])

    unless @pending_registration
      redirect_to register_path,
                  alert: "Please register again."
      return
    end

    # Handle expired pending registration
    if @pending_registration.expired?
      @pending_registration.destroy
      session.delete(:pending_registration_id)

      redirect_to register_path,
                  alert: "Registration session expired. Please register again."
    end
  end

  def complete_registration_verification
    @pending_registration =
      PendingRegistration.find_by(id: session[:pending_registration_id])

    unless @pending_registration
      redirect_to register_path,
                  alert: "Verification session expired. Please register again."
      return
    end

    if @pending_registration.expired?
      @pending_registration.destroy
      session.delete(:pending_registration_id)

      redirect_to register_path,
                  alert: "Registration session expired. Please register again."
      return
    end

    email_result = VerificationOtpService.verify(
      pending_registration: @pending_registration,
      purpose: "EMAIL_VERIFICATION",
      otp: params[:email_otp]
    )

    if email_result[:success]
    User.transaction do 
     user =  User.create!(
        name: @pending_registration.name,
        email: @pending_registration.email,
        phone: @pending_registration.phone,
        password_digest: @pending_registration.password_digest,
        email_verified_at: Time.current
      )
      user_role = Role.find_by!(name: "USER")

      UserRole.create!(
      user: user,
      role: user_role
      )
    end

      @pending_registration.destroy
      session.delete(:pending_registration_id)

      redirect_to login_path,
                  notice: "Email verified successfully. You can now login."
    else
      flash.now[:alert] = "Email OTP: #{email_result[:message]}"

      render :verify_registration,
             status: :unprocessable_entity
    
    end
  end

def resend_otp
  @pending_registration =
    PendingRegistration.find_by(id: session[:pending_registration_id])

  unless @pending_registration
    redirect_to register_path,
                alert: "Verification session expired. Please register again."
    return
  end

  if @pending_registration.expired?
    @pending_registration.destroy
    session.delete(:pending_registration_id)

    redirect_to register_path,
                alert: "Registration session expired. Please register again."
    return
  end

  if @pending_registration.otp_sent_at.present? &&
     @pending_registration.otp_sent_at > 2.minutes.ago

    redirect_to verify_registration_path,
                alert: "Please wait before requesting another OTP."
    return
  end

  generate_verification_otps

  redirect_to verify_registration_path,
              notice: "OTP sent successfully"
end




  private

  def user_params
    params.require(:user).permit(
      :name,
      :email,
      :phone,
      :password,
      :password_confirmation
    )
  end

  def generate_verification_otps
    email_result = VerificationOtpService.generate(
      pending_registration: @pending_registration,
      purpose: "EMAIL_VERIFICATION"
    )

    VerificationMailer.with(
      recipient: @pending_registration,
      otp: email_result[:otp],
      purpose: "EMAIL_VERIFICATION"
    ).otp.deliver_now

   @pending_registration.update!(
    otp_sent_at: Time.current
   )
  end

end
