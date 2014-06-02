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

end
