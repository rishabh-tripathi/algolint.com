class ContainerStack < ActiveRecord::Base
  attr_accessible :compiler_id, :count, :created_by, :dependency, :image_id, :image_type, :language_id, :name, :status

  IMAGE_TYPE_COMPILER = 0
  IMAGE_TYPE_CUSTOM = 10

  IMAGE_TYPE_NAMES = {
    IMAGE_TYPE_COMPILER => "Compiler",
    IMAGE_TYPE_CUSTOM => "Custom"
  }

  STATUS_STOPPED = 0
  STATUS_RUNNING = 1
  STATUS_ERROR = 2

  STATUS_NAMES = {
    STATUS_STOPPED => "Stopped",
    STATUS_RUNNING => "Running",
    STATUS_ERROR => "Error"
  }
  
end
