class Container < ActiveRecord::Base
  attr_accessible :assigned_to, :host, :image_id, :port, :stack_id, :status, :type
  
  STATUS_CREATED = 1
  STATUS_RESTARTING = 2
  STATUS_RUNNING = 3
  STATUS_PAUSHED = 4
  STATUS_EXITED = 5

  STATUS_NAMES = {
    STATUS_CREATED => "Created",
    STATUS_RESTARTING => "Restarting",
    STATUS_RUNNING => "Running",
    STATUS_PAUSHED => "Paushed",
    STATUS_EXITED => "Exited"
  }
end
