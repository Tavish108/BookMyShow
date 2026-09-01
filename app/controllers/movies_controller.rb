class MoviesController < ApplicationController
  before_action :require_login
  before_action :set_movie, only: [:show, :edit, :update, :destroy]
  before_action :require_content_admin_or_super_admin, only: [:new, :create, :edit, :update, :destroy]
  before_action :authorize_movie_management, only: [:edit, :update, :destroy]

  def index
    if current_user.has_role?("SUPER_ADMIN")
      @movies = Movie.includes(:language, :genres)
    elsif current_user.has_role?("CONTENT_ADMIN")
      @movies = current_user.created_movies.includes(:language)
    else
      @movies = Movie.includes(:language)
    end

    if params[:search].present?
      @movies = @movies.where(
        "title ILIKE ?",
        "%#{params[:search]}%"
      )
    end

  end

def show
  @movie = Movie.includes(
    :language,
    :genres,
    shows: [:theatre, :auditorium]
  ).find(params[:id])

  @shows = @movie.shows
                 .where(status: "ACTIVE")
                 .where("show_date >= ?", Date.current)
                 .order(:show_date, :start_time)
end

  def new
    @movie = Movie.new
    @languages = Language.order(:name)
    @genres = Genre.order(:name)
  end

  def create
    @movie = current_user.created_movies.build(movie_params)

    if @movie.save
      redirect_to movie_path(@movie), notice: "Movie created successfully."
    else
      @languages = Language.order(:name)
      @genres = Genre.order(:name)
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  @languages = Language.order(:name)
  @genres = Genre.order(:name)
  end

  def update
    if @movie.update(movie_params)
      redirect_to movie_path(@movie), notice: "Movie updated successfully."
    else
      @languages = Language.order(:name)
      @genres = Genre.order(:name)
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @movie.destroy

    redirect_to movies_path, notice: "Movie deleted successfully."
  end

  private

  def set_movie
   @movie = Movie.includes(:language, :genres).find(params[:id])
  end

  def movie_params
    params.require(:movie).permit(
      :title,
      :description,
      :duration_minutes,
      :release_date,
      :language_id,
      :certificate,
      :status,
      :poster_url,
      :trailer_url,
      genre_ids: []
    )
  end

  def require_content_admin_or_super_admin
    require_role("CONTENT_ADMIN", "SUPER_ADMIN")
  end

  def authorize_movie_management
    return if current_user.has_role?("SUPER_ADMIN")
    return if current_user.has_role?("CONTENT_ADMIN") &&
              @movie.created_by_id == current_user.id

    redirect_to movies_path, alert: "You are not authorized to manage this movie."
  end

private





end