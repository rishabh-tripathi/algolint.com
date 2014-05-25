class HomeController < ApplicationController
  
  def homepage
    if(current_user.present?)
      if(current_user.last_open_file.present?)
        @file = Content.find(current_user.last_open_file)
      end
    end
  end

  def save_file
    if(current_user.present?) 
      if(params[:file_id].present?)
        content = Content.find(params[:file_id].to_i)        
      else
        content = Content.new
      end
      content.user_id = current_user.id
      content.name = params[:file_name]
      content.desc = params[:file_desc]
      content.content = params[:file_content]
      content.save
      current_user.last_open_file = content.id
      current_user.save
      render(:partial => "save_file_res", :locals => {:file => content}) 
    else
      render(:text => "Unauthorize")
    end
  end

end
