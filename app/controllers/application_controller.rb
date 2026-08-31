class ApplicationController < ActionController::Base
  helper_method :current_user, :logged_in?

  private

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def logged_in?
    current_user.present?
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Please log in first."
    end
  end

def require_role(*roles)
  unless logged_in?
    redirect_to login_path, alert: "Please log in first."
    return
  end

  unless roles.any? { |role| current_user.has_role?(role) }
    redirect_to root_path, alert: "You are not authorized to perform this action."
  end
end

  def require_super_admin
    require_role("SUPER_ADMIN")
  end

  
  def dashboard_path_for_current_user
    if current_user.has_role?("SUPER_ADMIN")
      super_admin_dashboard_path
    elsif current_user.has_role?("THEATRE_ADMIN")
      theatre_admin_dashboard_path
    elsif current_user.has_role?("CONTENT_ADMIN")
      content_admin_dashboard_path
    else
      user_dashboard_path
    end
  end

  helper_method :dashboard_path_for_current_user

end