class SeatsController < ApplicationController
  before_action :set_theatre
  before_action :set_auditorium
  before_action :set_seat, only: %i[show edit update destroy]

  def index
    @seats = @auditorium.seats
  end

  def show
  end

  def new
    @seat = @auditorium.seats.new
  end

  def create
    @seat = @auditorium.seats.new(seat_params)

    if @seat.save
      redirect_to theatre_auditorium_seat_path(
        @theatre,
        @auditorium,
        @seat
      ), notice: "Seat was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @seat.update(seat_params)
      redirect_to theatre_auditorium_seat_path(
        @theatre,
        @auditorium,
        @seat
      ), notice: "Seat was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @seat.destroy

    redirect_to theatre_auditorium_path(
      @theatre,
      @auditorium
    ), notice: "Seat was successfully deleted."
  end

  private

  def set_theatre
    @theatre = Theatre.find(params[:theatre_id])
  end

  def set_auditorium
    @auditorium = @theatre.auditoriums.find(params[:auditorium_id])
  end

  def set_seat
    @seat = @auditorium.seats.find(params[:id])
  end

  def seat_params
    params.require(:seat).permit(
      :row_name,
      :seat_number,
      :seat_type,
      :seat_category
    )
  end
end
