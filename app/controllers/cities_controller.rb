class CitiesController < ApplicationController
  before_filter :require_user
  before_filter :retrieve_city, :only => [:show, :manage]

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
  end

  def index
    @cities = current_user.cities
  end

  def manage
    begin
      command = CityRules.handle!(params[:command], :city => @city)
      flash[:notice] = command.message
    rescue UserActionError => error
      flash[:alert] = error.message
    end
    redirect_to city_path(@city)
  end

  private
    def retrieve_city
      @city = current_user.cities.find(params[:id])
    end
end
