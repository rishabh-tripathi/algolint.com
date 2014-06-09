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
  
  def get_folder_path
    return "./user_codes/#{self.user_id}/#{Content::TYPE_NAMES[self.file_type]}"
  end
  
  def get_file_path
    "#{self.get_folder_path}/#{self.name}"
  end

  def get_final_code
    content = self.content
    content = content.gsub(/<br>/,"\n").gsub("&nbsp;"," ").gsub("&lt;","<").gsub("&gt;",">").gsub("<div>","").gsub("</div>","")
    return content
  end

  def compile_code
    output = ""
    if(self.file_type == Content::TYPE_CODE_CPP)
      system("cc -o #{self.get_folder_path}/compile/#{self.id} #{self.get_file_path}")
      system("#{self.get_folder_path}/compile/#{self.id} > #{self.get_folder_path}/compile/op/#{self.id}")
      output = File.read("#{self.get_folder_path}/compile/op/#{self.id}")      
    elsif(self.file_type == Content::TYPE_CODE_JAVA)
      system("javac #{self.get_file_path}")
      system("java #{self.get_file_path.gsub(/.java/,'')} > #{self.get_folder_path}/compile/op/#{self.id}")
    elsif(self.file_type == Content::TYPE_CODE_RUBY)
      system("ruby #{self.get_file_path} > #{self.get_folder_path}/compile/op/#{self.id}")      
      output = File.read("#{self.get_folder_path}/compile/op/#{self.id}")         
    elsif(self.file_type == Content::TYPE_CODE_PYTHON)            
    end
    return output
  end

end
