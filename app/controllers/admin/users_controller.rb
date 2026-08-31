class Admin::UsersController < ApplicationController
  before_action :require_super_admin
  before_action :set_user, only: [:edit, :update]

  def index
    @users = User.includes(:roles).order(:id)
  end

  def edit
    @roles = Role.order(:name)
  end

  def update
    role_ids = Array(params[:role_ids]).reject(&:blank?)

    @user.user_roles.destroy_all
    @user.roles = Role.where(id: role_ids)

    redirect_to admin_users_path, notice: "User roles updated successfully."
  end

  private

  def set_user
    @user = User.find(params[:id])
  end
end