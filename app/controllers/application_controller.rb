class ApplicationController < ActionController::Base
  allow_browser versions: :modern
  
  before_action :require_authentication
  
  private
  
  def require_authentication
    unless session[:authenticated] || is_public_page?
      redirect_to login_path, alert: "Authentification requise"
    end
  end
  
  def is_public_page?
    controller_name == 'sessions' || (controller_name == 'player' && action_name.start_with?('radio'))
  end
end