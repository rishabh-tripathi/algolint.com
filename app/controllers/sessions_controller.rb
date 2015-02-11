class SessionsController < Devise::SessionsController
  respond_to :json, :html

  def new
    super
  end

  def create    
    resource = warden.authenticate!(auth_options)
    sign_in(resource_name, resource)
    render json: { auth_token: current_user.authentication_token }    
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
