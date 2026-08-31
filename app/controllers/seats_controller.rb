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

  def generate
    start_row = params[:start_row].to_s.upcase
    end_row = params[:end_row].to_s.upcase
    seats_per_row = params[:seats_per_row].to_i
    seat_type = params[:seat_type]
    seat_category = params[:seat_category]

    if start_row.blank? || end_row.blank? || seats_per_row <= 0
      redirect_to theatre_auditorium_path(@theatre, @auditorium),
                alert: "Please provide valid seat generation details."
      return
    end

    start_code = start_row.ord
    end_code = end_row.ord

    if start_code > end_code
      redirect_to theatre_auditorium_path(@theatre, @auditorium),
                alert: "End row must come after start row."
      return
    end

    rows = (start_code..end_code).map(&:chr)

    requested_seats = rows.length * seats_per_row
    existing_seats = @auditorium.seats.count

    if existing_seats + requested_seats > @auditorium.capacity
      remaining = @auditorium.capacity - existing_seats

      redirect_to theatre_auditorium_path(@theatre, @auditorium),
                alert: "Only #{remaining} seats can be added."
      return
    end

    rows.each do |row|
      (1..seats_per_row).each do |number|
        @auditorium.seats.create!(
          row_name: row,
          seat_number: number,
          seat_type: seat_type,
          seat_category: seat_category
        )
      end
    end

  redirect_to theatre_auditorium_path(@theatre, @auditorium),
              notice: "#{requested_seats} seats were successfully generated."
  rescue ActiveRecord::RecordNotUnique
    redirect_to theatre_auditorium_path(@theatre, @auditorium),
                alert: "Some seats already exist."
  
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
