class Like < ActiveRecord::Base
  attr_accessible :obj_id, :obj_type, :user_id
  
  OBJ_TYPE_CODE = 10
  OBJ_TYPE_PROFILE = 20
  
  OBJ_TYPE_NAMES = {
    OBJ_TYPE_CODE => "Code",
    OBJ_TYPE_PROFILE => "Profile"
  }

  def self.is_user_liked(obj_type, obj_id, user_id)
    like_obj = Like.find(:first, :conditions => ["obj_type = ? and obj_id = ? and user_id = ?", obj_type, obj_id, user_id])
    return (like_obj.present?)? [true, like_obj] : [false, nil]
  end
  
  def self.get_obj_likes(obj_type, obj_id)
    likes = Like.count(:all, :conditions => ["obj_type = ? and obj_id = ?", obj_type, obj_id])
    return likes
  end

  def self.like_obj(obj_type, obj_id, user_id)
    (liked, like_obj) = Like.is_user_liked(obj_type, obj_id, user_id)
    if(liked)
      like_obj.destroy
    else
      like_obj = Like.new
      like_obj.obj_type = obj_type
      like_obj.obj_id = obj_id
      like_obj.user_id = user_id
      like_obj.save
    end
    like_count = Like.get_obj_likes(obj_type, obj_id)
    return like_count
  end
end
