class SessionsController < Devise::SessionsController
  respond_to :json, :html

  def new
    super
  end

  def create    
    resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    if(params[:format].present? && params[:format] == "json")
      render :text => current_user.authentication_token
    else
      redirect_to root_path
    end
  end
  
  def destroy
    current_user.authentication_token = nil
    super
  end

  protected
  def verified_request?
    request.content_type == "application/json" || super
  end 
end
