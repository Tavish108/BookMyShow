class AdminController < ApplicationController
  before_action -> { require_role("SUPER_ADMIN") }

  def index
    render json: {
      message: "Welcome Super Admin",
      user: current_user.name,
      roles: current_user.roles.pluck(:name)
    }
  end
end