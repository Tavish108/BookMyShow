class DashboardsController < ApplicationController
  before_action :require_login

  def user
    require_role("USER")
  end

  def theatre_admin
    require_role("THEATRE_ADMIN", "SUPER_ADMIN")

    @theatres = current_user.created_theatres.includes(:auditoriums)

    @theatre_reports = @theatres.index_with do |theatre|
      CollectionReport.for_theatre(theatre)
    end
  end

  def content_admin
    require_role("CONTENT_ADMIN", "SUPER_ADMIN")

     @movies = current_user.created_movies.includes(:language)
  end

  def super_admin
    require_super_admin

    @movie_collections = CollectionReport.movie_collections
  end
end