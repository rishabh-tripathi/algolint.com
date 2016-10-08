class UserCompile < ActiveRecord::Base
  attr_accessible :compiler_id, :content_id, :dependency, :language_id, :status, :user_id
end
