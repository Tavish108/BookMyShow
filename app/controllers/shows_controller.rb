class ShowsController < ApplicationController
  before_action :require_login
  before_action :require_show_access

  before_action :set_show, only: %i[show edit update destroy]
  def index
    @shows = accessible_shows
              .includes(:movie, :theatre, :auditorium)
              .order(show_date: :asc, start_time: :asc)
  end

  def show
  end

  def new
    @show = Show.new
    load_form_data
  end

  def create
    @show = Show.new(show_params)

    unless accessible_theatre?(@show.theatre_id)
      @show.errors.add(:theatre, "is not managed by you")
      load_form_data
      return render :new, status: :unprocessable_entity
    end

    unless auditorium_belongs_to_selected_theatre?
      @show.errors.add(
        :auditorium,
        "must belong to the selected theatre"
      )
      load_form_data
      return render :new, status: :unprocessable_entity
    end

    if @show.save
      redirect_to @show, notice: "Show was successfully created."
    else
      load_form_data
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    load_form_data
  end

  def update
    unless accessible_theatre?(@show.theatre_id)
      @show.errors.add(:theatre, "is not managed by you")
      load_form_data
      return render :edit, status: :unprocessable_entity
    end

    unless auditorium_belongs_to_selected_theatre?
      @show.errors.add(
        :auditorium,
        "must belong to the selected theatre"
      )
      load_form_data
      return render :edit, status: :unprocessable_entity
    end

    if @show.update(show_params)
      redirect_to @show, notice: "Show was successfully updated."
    else
      load_form_data
      render :edit, status: :unprocessable_entity
    end
  end


  def destroy
    @show.destroy
    redirect_to shows_path, notice: "Show was successfully deleted."
  end

  private

  def require_show_access
    require_role("THEATRE_ADMIN", "SUPER_ADMIN")
  end

  def set_show
    @show = accessible_shows.find_by(id: params[:id])

    return if @show.present?

    redirect_to shows_path, alert: "SHow not found."
  end

  def accessible_shows
    if current_user.has_role?("SUPER_ADMIN")
      Show.all
    else
      Show.joins(:theatre)
           .where(theatres: { created_by_id: current_user.id })
    end
  end

  def accessible_theatres
    if current_user.has_role?("SUPER_ADMIN")
      Theatre.where(status: "ACTIVE")
    else
      current_user.created_theatres.where(status: "ACTIVE")
    end
  end

  def accessible_theatre?(theatre_id)
    accessible_theatres.exists?(id: theatre_id)
  end

  def load_form_data
    @movies = Movie.all
    @theatres = accessible_theatres

    @auditoriums =
      if @show.theatre_id.present?
        @theatres.find_by(id: @show.theatre_id)&.auditoriums || Auditorium.none
      else
        @theatres.includes(:auditoriums).flat_map(&:auditoriums)
      end
  end

  def auditorium_belongs_to_selected_theatre?
    return false if @show.theatre_id.blank? || @show.auditorium_id.blank?

    Auditorium.exists?(
      id: @show.auditorium_id,
      theatre_id: @show.theatre_id
    )
  end

  def show_params
    params.require(:show).permit(
      :movie_id,
      :theatre_id,
      :auditorium_id,
      :show_date,
      :start_time,
      :end_time,
      :price,
      :status
    )
  end
end
