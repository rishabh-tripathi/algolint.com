class HomeController < ApplicationController
  before_filter :check_for_admin, :only => [:admin, :list_codes, :make_template, :set_template_cat]
  
  def check_for_admin
    if(current_user.present? && current_user.is_admin_user)
      return true
    else
      redirect_to root_path
    end
  end

  def homepage
    if(current_user.present?)
      if(!current_user.unique_key.present?)
        current_user.set_unique_key
      end
      if(current_user.last_open_file.present?)
        @file = Content.find(current_user.last_open_file)        
      end
      @all_files = current_user.contents
      @uid = current_user.unique_key
    end
  end
  
  def compile_code 
    if(current_user.present? && params[:file_id].present?)
      fileObj = Content.find(params[:file_id].to_i)
      file_path = fileObj.get_folder_path
      FileUtils.mkdir_p("#{file_path}/compile/op")      
      File.open(fileObj.get_file_path, 'w') { |file| file.write(fileObj.get_final_code) }
      @output = fileObj.compile_code
      render(:text => @output)
    else
      render(:text => "No file to compile :(")
    end
  end

  def admin    
  end

  def list_codes
    @all_codes = Content.get_all_codes(current_user.id)
  end

  def make_template
    content = Content.find(params[:id])
    content.template = (content.template == Content::TEMPLATE_AL)? Content::TEMPLATE_NO : Content::TEMPLATE_AL
    content.save
    redirect_to list_codes_url
  end

  def set_template_cat    
    content = Content.find(params[:id])
    content.template_cat = params[:cat].to_i
    content.save    
    redirect_to list_codes_url    
  end

end
