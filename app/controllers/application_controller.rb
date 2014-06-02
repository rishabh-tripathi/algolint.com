class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :except => [:homepage]

  helper_method :check_credential
  def check_credential           
    if((request.format != :json) && current_user.present? && (current_user.is_admin > 0))
      redirect_to root_url
    end    
  end

end
