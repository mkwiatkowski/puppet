class CitiesController < ApplicationController
  before_filter :require_user

  def new
    @city = current_user.cities.new
  end

  def create
    @city = current_user.cities.create(params[:city])
    if @city.save
      redirect_to cities_path
    else
      render :new
    end
  end

  def show
    @city = current_user.cities.find(params[:id])
  end

  def index
    @cities = current_user.cities
  end
end
