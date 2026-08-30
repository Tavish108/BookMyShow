class AuditoriumsController < ApplicationController
  before_action :set_theatre
  before_action :set_auditorium, only: %i[show edit update destroy]
  def index
    @auditoriums = @theatre.auditoriums
  end

  def show
    @seats = @auditorium.seats
  end

  def new
    @auditorium = @theatre.auditoriums.new
  end

  def create
    @auditorium = @theatre.auditoriums.new(auditorium_params) # this automatically associated the auditorium with the theatre

    if @auditorium.save
      redirect_to theatre_auditorium_path(@theatre, @auditorium),
                    notice: "Auditorium was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @auditorium.update(auditorium_params)
      redirect_to theatre_auditorium_path(@theatre, @auditorium),
                    notice: "Auditorium was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @auditorium.destroy

    redirect_to theatre_path(@theatre),
                  notice: "Auditorium was successfully deleted."
  end

  private

  def set_theatre
    @theatre = Theatre.find(params[:theatre_id])
  end

  def set_auditorium
    @auditorium = @theatre.auditoriums.find(params[:id])
  end

  def auditorium_params
    params.require(:auditorium).permit(
      :name,
      :screen_type,
      :capacity
    )
  end
end
