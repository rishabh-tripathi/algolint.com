class Content < ActiveRecord::Base
  attr_accessible :compile, :content, :desc, :name, :sharability, :status, :type, :user_id
  belongs_to :user

end
