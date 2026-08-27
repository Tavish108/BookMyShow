class UsersController < ApplicationController
  
def new
  @user = User.new
end

def create
  @user = User.new(user_param)

  if @user.save
    user_role = Role.find_by!(name: "USER")
    @user.user_roles.create!(role: user_role)

    session[:user_id] = @user.id

    redirect_to me_path, notice: "Registration successful."
  else
    render :new, status: :unprocessable_entity
  end
end

 def me
  unless logged_in?
    redirect_to login_path, alert: "Please log in first."
    return
  end
 end


private
def user_param
  params.require(:user).permit(
    :name,
    :email,
    :phone,
    :password,
    :password_confirmation
  )
end
end