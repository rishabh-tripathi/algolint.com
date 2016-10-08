class ImageConfig < ActiveRecord::Base
  attr_accessible :access_config, :default_port, :dockerfile, :image_id, :image_type, :startup_config
end
