# ---------------------------------------------------------------------------------------
# A Rails 3 controller that:
# - Runs the through Dropbox's OAuth 2 flow, yielding a Dropbox API access token.
# - Makes a Dropbox API call to upload a file.
#
# To set up:
# 1. Create a Dropbox App key and secret to use the API. https://www.dropbox.com/developers
# 2. Add http://localhost:3000/dropbox/auth_finish as a Redirect URI for your Dropbox app.
# 3. Copy your App key and App secret into APP_KEY and APP_SECRET below.
#
# To run:
# 1. You need a Rails 3 project (to create one, run: rails new <folder-name>)
# 2. Copy dropbox_sdk.rb into <folder-name>/vendor
# 3. Copy this file into <folder-name>/app/controllers/
# 4. Add the following lines to <folder-name>/config/routes.rb
#        get  "dropbox/main"
#        post "dropbox/upload"
#        get  "dropbox/auth_start"
#        get  "dropbox/auth_finish"
# 5. Run: rails server
# 6. Point your browser at: https://localhost:3000/dropbox/main

require 'dropbox_sdk'
require 'securerandom'

APP_KEY = "r9oy1smycufztuq"
APP_SECRET = "bd9wsio75rbtzdi"

class DropboxController < ApplicationController

  def upload    
    if(current_user.present?)
      contents = Content.get_all_codes(current_user.id)
      if(contents.present?)
        client = get_dropbox_client
        unless client
          redirect_to(:action => 'auth_start') and return
        end            
        for c in contents
          begin
            # Upload the POST'd file to Dropbox, keeping the same name            
            if(c.folder_id != 0)
              folder = Folder.find(c.folder_id)
              file_name = "#{folder.name}/#{c.name}"
            else
              file_name = "#{c.name}"
            end
            resp = client.put_file(file_name, c.get_final_code)
            current_user.dropbox_sync_status = User::DROPBOX_SYNC_SUCCESS
            current_user.dropbox_last_sync_at = DateTime.now
            current_user.save
            current_user.reload
            logger.info("Upload successful. File now at #{resp['path']}")
          rescue DropboxAuthError => e
            current_user.dropbox_sync_status = User::DROPBOX_SYNC_FAILURE
            current_user.save
            current_user.reload
            session.delete(:access_token)  # An auth error means the access token is probably bad
            logger.info "Dropbox auth error: #{e}"
            render :text => "Dropbox auth error"
          rescue DropboxError => e
            current_user.dropbox_sync_status = User::DROPBOX_SYNC_FAILURE
            current_user.save
            current_user.reload
            logger.info "Dropbox API error: #{e}"
            render :text => "Dropbox API error"
          end          
        end        
        render :text => "Last Sync at #{current_user.dropbox_last_sync_at}"
      end
    else
      render :text => "Error"
    end
  end

  def get_dropbox_client
    if(session[:access_token])
      begin
        access_token = session[:access_token]
        DropboxClient.new(access_token)
      rescue
        # Maybe something's wrong with the access token?
        session.delete(:access_token)
        raise
      end
    else
      if(current_user.present? && current_user.dropbox_access_token.present?)        
        begin
          DropboxClient.new(current_user.dropbox_access_token)
        rescue
          raise
        end
      end
    end
  end
  
  def get_web_auth()
    redirect_uri = url_for(:action => 'auth_finish')    
    # DropboxOAuth2Flow.new(APP_KEY, APP_SECRET, redirect_uri, session, :dropbox_auth_csrf_token)
    DropboxOAuth2FlowNoRedirect.new(APP_KEY, APP_SECRET)
  end
  
  def auth_start
    authorize_url = get_web_auth().start()    
    # Send the user to the Dropbox website so they can authorize our app.  After the user
    # authorizes our app, Dropbox will redirect them here with a 'code' parameter.
    redirect_to authorize_url
  end

  def complete_integration
    begin 
      access_token, user_id = get_web_auth.finish(params[:access_code])      
      if(current_user.present?) 
        current_user.dropbox_uid = user_id
        current_user.dropbox_access_token = access_token
        current_user.dropbox_sync_status = User::DROPBOX_SYNC_NO
        current_user.save
        current_user.reload
      end
      render(:partial => "home/dropbox_status")
    rescue Exception => e
      logger.info(e)
      render(:text => "Error")
    end
  end
    
  def auth_finish
    begin
      access_token, user_id, url_state = get_web_auth.finish(params)
      session[:access_token] = access_token
      if(current_user.present?) 
        current_user.dropbox_uid = user_id
        current_user.dropbox_access_token = access_token
        current_user.dropbox_sync_status = User::DROPBOX_SYNC_NO
        current_user.save
        current_user.reload
      end
      redirect_to root_path
    rescue DropboxOAuth2Flow::BadRequestError => e
      render :text => "Error in OAuth 2 flow: Bad request: #{e}"
    rescue DropboxOAuth2Flow::BadStateError => e
      logger.info("Error in OAuth 2 flow: No CSRF token in session: #{e}")
      redirect_to(:action => 'auth_start')
    rescue DropboxOAuth2Flow::CsrfError => e
      logger.info("Error in OAuth 2 flow: CSRF mismatch: #{e}")
      render :text => "CSRF error"
    rescue DropboxOAuth2Flow::NotApprovedError => e
      render :text => "Not approved?  Why not, bro?"
    rescue DropboxOAuth2Flow::ProviderError => e
      logger.info "Error in OAuth 2 flow: Error redirect from Dropbox: #{e}"
      render :text => "Strange error."
    rescue DropboxError => e
      logger.info "Error getting OAuth 2 access token: #{e}"
      render :text => "Error communicating with Dropbox servers."
    end
  end
end
