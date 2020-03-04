class ApplicationController < ActionController::Base

  protected
  
  def after_sign_in_path_for(resource)
    current_user.is_first_login? ? instructions_path : (stored_location_for(resource) || root_path)
  end

end
