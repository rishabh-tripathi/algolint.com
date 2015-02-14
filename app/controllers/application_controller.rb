class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!, :except => [:homepage, :profile, :content_public, :how_to_use, :cli]
  before_filter :set_seo_tag
  
  def set_seo_tag
    @seo = {
      :title => "AlgoLint - Algorithm Practice Tool",
      :keyword => "Algorithm Practice Tool",
      :desc => "Online Algorithm Practice Tool"
    }
  end

  helper_method :check_credential
  def check_credential           
    if((request.format != :json) && current_user.present? && (current_user.is_admin > 0))
      redirect_to root_url
    end    
  end

end
