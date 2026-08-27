class TheatresController < ApplicationController
  before_action :set_theatre, only: %i[show edit update destroy]
  def index
    @theatres = Theatre.all
  end

  def show
  end

  def new
  end

  def edit
  end
end
