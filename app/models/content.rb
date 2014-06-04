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
    TYPE_CODE_CPP => "C/C++ Code",
    TYPE_CODE_JAVA => "Java Code",
    TYPE_CODE_RUBY => "Ruby Code",
    TYPE_CODE_PYTHON => "Python Code"
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
  
end
