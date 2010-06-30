class HomeController < ApplicationController
  def index
    redirect_to(cities_path) if current_user
  end
end
