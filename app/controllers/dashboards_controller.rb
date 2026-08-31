class DashboardsController < ApplicationController
  before_action :require_login

  def user
    require_role("USER")
  end

  def theatre_admin
    require_role("THEATRE_ADMIN", "SUPER_ADMIN")
    @theatres = current_user.created_theatres
  end

  def content_admin
     @movies = current_user.created_movies.includes(:language)
    require_role("CONTENT_ADMIN", "SUPER_ADMIN")
  end

  def super_admin
    require_super_admin
  end
end