class HomeController < ApplicationController
  
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

end
