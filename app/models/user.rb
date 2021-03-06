class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  before_save :ensure_authentication_token

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable, :token_authenticatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :authentication_token
  # attr_accessible :title, :body

  has_many :contents

  ADMIN_NO = 0
  ADMIN_USER = 10
  
  IS_ADMIN_NAMES = {    
    ADMIN_NO => "Not admin",
    ADMIN_USER => "Admin User"
  }
  
  KEY_EMACS = 10
  KEY_VIM = 20
  KEY_SUBLIME = 30
  
  KEY_CODE = {
    KEY_EMACS => "emacs",
    KEY_VIM => "vim",
    KEY_SUBLIME => "sublime" 
  }

  THEME_LIGHT = 0
  THEME_DARK = 10

  
  DROPBOX_SYNC_NO = 0
  DROPBOX_SYNC_SUCCESS = 10
  DROPBOX_SYNC_FAILURE = -10
  
  DROPBOX_SYNC_NAMES = {
    DROPBOX_SYNC_NO => "Not Sync",
    DROPBOX_SYNC_SUCCESS => "Sync Success",
    DROPBOX_SYNC_FAILURE => "Sync Failed"
  }

  def set_unique_key
    size = 20
    s = ""
    size.times { s << (i = Kernel.rand(62); i += ((i < 10) ? 48 : ((i < 36) ? 55 : 61 ))).chr }
    self.unique_key = s
    self.save
  end
  
  def get_display_name 
    return self.email.split("@").first
  end

  def get_url_name 
    return (self.url_name.present?)? "#{self.url_name}" : "#{self.unique_key}"
  end

  def is_admin_user
    return (self.is_admin == User::ADMIN_USER)? true : false
  end

end
