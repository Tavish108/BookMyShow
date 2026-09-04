class TheatresController < ApplicationController
  before_action :require_login
  before_action :set_theatre, only: %i[show edit update destroy sales_record]

  def index
    @theatres = current_user.created_theatres
  end

  def show
    @auditoriums = @theatre.auditoriums
  end

  def new
    @theatre = Theatre.new
  end

  def create
    @theatre = current_user.created_theatres.build(theatre_params)

    if @theatre.save
      redirect_to @theatre, notice: "Theatre was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @theatre.update(theatre_params)
      redirect_to @theatre, notice: "Theatre was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @theatre.destroy
    redirect_to theatres_path, notice: "Theatre was successfully deleted."
  end


    def sales_record
  @theatre_report = CollectionReport.for_theatre(@theatre)
    end
  private

  def set_theatre
    @theatre = current_user.created_theatres.find(params[:id])
  end

  def theatre_params
    params.require(:theatre).permit(
      :name,
      :address,
      :city,
      :state,
      :postal_code,
      :phone,
      :email,
      :status
    )
  end
end
