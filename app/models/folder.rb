class Folder < ActiveRecord::Base
  attr_accessible :name, :parent_id, :user_id
end
