class SessionsController < ApplicationController
  def new
    redirect_to dashboard_path_for_current_user if logged_in?
    @user = User.new
  end

  def create
    login_input = params[:email].to_s.strip

    user = if login_input.include?("@")
             User.find_by(email: login_input.downcase)
           else
             User.find_by(phone: login_input)
           end

    if user&.authenticate(params[:password])
      unless user.email_verified_at.present?
        flash.now[:alert] = "Please verify your email and mobile number before logging in."
        render :new, status: :unprocessable_entity
        return
      end

      reset_session
      session[:user_id] = user.id

      redirect_to dashboard_path_for_current_user
    else
      flash.now[:alert] = "Invalid email/phone or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    reset_session
    redirect_to login_path, notice: "Logged out successfully."
  end
end