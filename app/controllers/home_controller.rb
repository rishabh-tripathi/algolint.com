class HomeController < ApplicationController
  before_filter :check_for_admin, :only => [:admin, :list_codes, :list_users, :make_template, :set_template_cat]
  
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
        if(params[:file].present?)
          current_user.last_open_file = params[:file].to_i
          current_user.save
        end
        @file = Content.find(current_user.last_open_file)        
      end
      @all_files = current_user.contents
      @uid = current_user.unique_key
    end
  end

  def get_profile_name
    if(current_user.present? && current_user.url_name.blank?)
      render(:layout => "blank")
    else
      redirect_to root_path
    end
  end

  def check_profile_name_avail
    user = User.find(:first, :conditions => ["url_name = ? or unique_key = ?", params[:pro_name], params[:pro_name]])
    if(user.present?)
      @avail = false
    else
      @avail = true
      @profile_name = params[:pro_name].to_s.gsub(" ","-").gsub(".","-")
    end
    render(:partial => "profile_name_check_res")
  end

  def save_profile_url
    user = User.find(:first, :conditions => ["url_name = ? or unique_key = ?", params[:pro_name], params[:pro_name]])
    if(user.present?)
      redirect_to get_profile_name_url
    else
      current_user.url_name = params[:pro_name]
      current_user.save
      current_user.reload
      redirect_to root_path
    end    
  end

  def set_default_user_editor_setting
    if(current_user.present?)
      if(params[:keybind].present?)
        current_user.default_keybind = params[:keybind].to_i
      end
      if(params[:fontsize].present?)
        current_user.default_font_size = params[:fontsize].to_i
      end
      if(params[:theme].present?) 
        current_user.default_theme = params[:theme].to_i
      end
      if(current_user.save)
        render(:text => "Preference has been saved")
      else
        render(:text => "Preference has not been saved")
      end
    end
  end
  
  def compile_code 
    if(current_user.present? && params[:file_id].present?)
      fileObj = Content.find(params[:file_id].to_i)
      file_path = fileObj.get_folder_path
      FileUtils.mkdir_p("#{file_path}")      
      File.open(fileObj.get_file_path, 'w') { |file| file.write(fileObj.get_final_code) }
      @output = fileObj.compile_code      
      fileObj.compile = 0 if(fileObj.compile.nil?)
      fileObj.compile = fileObj.compile + 1
      fileObj.save
      fileObj.reload
      render(:text => @output)
    else
      render(:text => "No file to compile :(")
    end
  end

  def profile
    @user = User.find(:first, :conditions => ["url_name =  ? or unique_key = ?", params[:uid], params[:uid]])
    if(@user.present?)
      @contents = Content.get_all_public_codes(@user.id)
      @seo = {
        :title => "#{@user.get_display_name} Codes",
        :keyword => "#{@user.get_display_name} Codes, Algorithm Practice Tool",
        :desc => "#{@user.get_display_name} Codes on Algolint your online algorithm Practice Tool"
      }
    end
    render :layout => "profile"
  end

  def content_public
    @user = User.find(:first, :conditions => ["email like ?", "#{params[:uid]}%"])
    if(@user.present?)
      @content = Content.find(params[:file_id])
      if(@content.view_count.nil?)
        @content.view_count = 0
      end
      @content.view_count += 1 
      @content.save
      @like_count = Like.get_obj_likes(Like::OBJ_TYPE_CODE, @content.id)
      @seo = {
        :title => "#{@user.get_display_name} > #{@content.name}",
        :keyword => "#{@user.get_display_name} Codes, Algorithm Practice Tool",
        :desc => "#{@user.get_display_name} Codes on Algolint your online algorithm Practice Tool"
      }
      if(!@content.present?)
        redirect_to profile_url(:uid => params[:uid])
      else
        render :layout => "profile"
      end
    else      
      redirect_to root_path
    end
  end

  def like_code
    if(current_user.present?)
      content = Content.find(params[:code_id])
      if(content.present?)
        count = Like.like_obj(Like::OBJ_TYPE_CODE, params[:code_id], current_user.id)             
        content.like_count = count
        content.save
        render(:text => count)      
      end
    end
  end
  
  def how_to_use
  end

  def explore
  end

  # Admin Methods ###################################################################
  def admin    
  end

  def list_codes
    @all_codes = Content.get_all_codes(current_user.id)
  end

  def list_users
    @all_users = User.all
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
  ###################################################################################
end
