class Compiler < ActiveRecord::Base
  attr_accessible :description, :image_id, :language_id, :name, :run_config
end
