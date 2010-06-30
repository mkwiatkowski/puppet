class ApplicationController < ActionController::Base
  protect_from_forgery
  layout 'application'

  def require_user
    unless current_user
      flash[:notice] = "You must be logged in to access this page"
      redirect_to new_user_session_path
    end
  end
end
