class Content < ActiveRecord::Base
  attr_accessible :compile, :content, :desc, :name, :sharability, :status, :file_type, :user_id, :template, :template_cat
  belongs_to :user

  TYPE_NOTE = 0
  TYPE_CODE_CPP = 10
  TYPE_CODE_JAVA = 20
  TYPE_CODE_RUBY = 30
  TYPE_CODE_PYTHON = 40
  
  TYPE_NAMES = {
    TYPE_NOTE => "Notes",
    TYPE_CODE_CPP => "C++",
    TYPE_CODE_JAVA => "Java",
    TYPE_CODE_RUBY => "Ruby",
    TYPE_CODE_PYTHON => "Python"
  }

  TYPE_EXT = {
    TYPE_NOTE => "",
    TYPE_CODE_CPP => "cpp",
    TYPE_CODE_JAVA => "java",
    TYPE_CODE_RUBY => "rb",
    TYPE_CODE_PYTHON => "py"  
  }

  STATUS_NEW = 0
  STATUS_COMPILED = 10
  STATUS_WARNING = 20
  STATUS_ERROR = 30

  STATUS_NAMES = {
    STATUS_NEW => "New File",
    STATUS_COMPILED => "Compiled",
    STATUS_WARNING => "Compiled with warning",
    STATUS_ERROR => "Compiled with error"
  }

  SHARE_PRIVATE = 0
  SHARE_PUBLIC = 10
  
  SHARE_NAME = {
    SHARE_PRIVATE => "Private",
    SHARE_PUBLIC => "Public"
  }
  
  TEMPLATE_NO = 0
  TEMPLATE_AL = 10
  TEMPLATE_USER = 20

  TEMPLATE_NAMES = {
    TEMPLATE_NO => "Not a template",
    TEMPLATE_AL => "Algolint Template",
    TEMPLATE_USER => "User Template"
  }

  TEMPLATE_CAT_NONE = 0
  TEMPLATE_CAT_LINKEDLIST = 10
  TEMPLATE_CAT_STACK = 20
  TEMPLATE_CAT_QUEUE = 30
  
  TEMPLATE_CAT_NAMES = {
    TEMPLATE_CAT_NONE => "Not a template",
    TEMPLATE_CAT_LINKEDLIST => "Linked List",
    TEMPLATE_CAT_STACK => "Stack",
    TEMPLATE_CAT_QUEUE => "Queue"
  }
  

  def get_folder_path
    return "./user_codes/#{self.user_id}/#{Content::TYPE_NAMES[self.file_type]}/#{self.id}"
  end
  
  def get_file_path
    "#{self.get_folder_path}/#{self.name}"
  end

  def get_final_code
    content = self.content
    content = content.gsub(/<br>/,"\n").gsub("&nbsp;"," ").gsub("&lt;","<").gsub("&gt;",">").gsub("<div>","").gsub("</div>","")    
    return content
  end
  
  def compile_code(cli=false)
    output = ""
    if(self.file_type == Content::TYPE_CODE_CPP)
      system("rm #{self.get_folder_path}/#{self.id}.compilestat")
      system("rm #{self.get_folder_path}/#{self.id}.op") 
      system("rm #{self.get_folder_path}/#{self.id}")       
      system("g++ -o #{self.get_folder_path}/#{self.id} #{self.get_file_path} 2> #{self.get_folder_path}/#{self.id}.compilestat")
      system("#{self.get_folder_path}/#{self.id} > #{self.get_folder_path}/#{self.id}.op")      
    elsif(self.file_type == Content::TYPE_CODE_JAVA)
      system("rm #{self.get_folder_path}/#{self.id}.compilestat")
      system("rm #{self.get_folder_path}/#{self.id}.op") 
      system("rm #{self.get_folder_path}/#{self.name.gsub(/.java/,'.class')}")  
      system("cd #{self.get_folder_path} && javac #{self.name} 2> #{self.id}.compilestat")
      system("cd #{self.get_folder_path} && java #{self.name.gsub(/.java/,'')} 1> #{self.id}.op")      
    elsif(self.file_type == Content::TYPE_CODE_RUBY)
      system("ruby #{self.get_file_path} 2> #{self.get_folder_path}/#{self.id}.compilestat")            
      system("ruby #{self.get_file_path} 1> #{self.get_folder_path}/#{self.id}.op")      
    elsif(self.file_type == Content::TYPE_CODE_PYTHON)    
      system("python #{self.get_file_path} 2> #{self.get_folder_path}/#{self.id}.compilestat")            
      system("python #{self.get_file_path} 1> #{self.get_folder_path}/#{self.id}.op")        
    end
    output_text = File.read("#{self.get_folder_path}/#{self.id}.op")
    error_text = File.read("#{self.get_folder_path}/#{self.id}.compilestat")
    output = ""
    output += "<span class='error'>" if(!cli)
    output += error_text
    output += "</span>" if(!cli)      
    output += output_text      
    output = output.gsub("#{self.get_folder_path}","")
    output = output.gsub("/#{self.name}","<br>/#{self.name}")    
    if(!output_text.blank?)
      self.output_text = output_text.gsub("#{self.get_folder_path}","").gsub("/#{self.name}","<br>/#{self.name}")
      self.status = Content::STATUS_COMPILED
    elsif(!error_text.blank?)
      self.output_text = error_text.gsub("#{self.get_folder_path}","").gsub("/#{self.name}","<br>/#{self.name}")
      self.status = Content::STATUS_ERROR      
    end
    return output
  end

  def self.get_all_codes(user_id)
    return Content.find(:all, :conditions => ["user_id = ?", user_id])    
  end
  
  def self.get_all_public_codes(user_id)
    return Content.find(:all, :conditions => ["user_id = ? and template = ? and sharability = ?", user_id, Content::TEMPLATE_NO, Content::SHARE_PUBLIC])    
  end

  def get_file_name_for_url
    return self.name.gsub(".","-").gsub(" ","-")
  end
  
end
