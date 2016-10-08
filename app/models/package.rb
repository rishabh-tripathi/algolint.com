class Package < ActiveRecord::Base
  attr_accessible :access, :description, :how_to, :name, :type, :version
end
