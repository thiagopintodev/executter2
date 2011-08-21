class User < ActiveRecord::Base
      #cached_followings_user_ids    1,2,3,4,5
      #privileges_string             admin,spy,master
      #relations_count_string        followers:15,friends:3,followings:10,mentions:80
      #posts_count_string            status:15,image:3,audio:10,other:80,all:200

  #CONSTANTS

  #used in post_helper
  #USERNAME_REGEX_NOT = /[^a-zA-Z0-9_-]/
  #used in UsernameValidator and others
  #USERNAME_REGEX = /[a-zA-Z0-9_-]{2,}/
  USERNAME_REGEX = /[a-z0-9_]{2,}/i
  #used in EmailValidator
  EMAIL_REGEX = /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i
  #NAME_REGEX = /^([0-9\^<,@\/\{\}\(\)\*\$%\?=>:\|;#]+)/ix


  
  include UserModuleAuthentication
  include UserModuleCustomize
  include UserModuleRelations
  include UserModuleKeyValueStore
  
  #VALIDATIONS

  validates :first_name,
  #          :format => {:with => NAME_REGEX },
            :presence => true, :length => { :in => 2..16 }
  validates :last_name,
            :presence => true, :length => { :in => 2..32 }
  
  #validate :custom_validations

  #def custom_validations
    #errors.add(:username, "username is not valid or is already taken") unless User.username_allowed username
  #end
  
  attr_accessor :city#, :user_photo_id
  #invites_count


  def fullname
    "#{first_name} #{last_name}"
  end
  def username_at
    "@#{username}"
  end
  
  def website_dots
    (!website or website.length <= 20) ? website : "#{website[0..20]}..."
  end

  
  
  has_many :posts,      :dependent => :destroy
  has_many :likes,      :dependent => :destroy
  has_many :invites,    :dependent => :destroy

  
  has_many :post_followers,  :dependent => :destroy
  has_many :post_user_news,  :dependent => :destroy



  

  def likes?(post_id)
    Like.likes?(self.id, post_id)
  end
  
  class << self
    #HELPER
    def create_sample
      s = MyF.chars
      a = new :username => s,
              :email    => "#{s}@executter.com",
              :password => s,
              :first_name    => "Nome",
              :last_name    => s
      a.register
      a
    end

    #CUSTOM METHODS
    def findi(param_id)
      where(:id=>param_id).first
    end
    def findu(param_username)
      where("lower(username)=?", param_username.downcase.delete("@")).first
    end
    def finde(param_email)
      where("lower(email)=?", param_email.downcase).first
    end
    
    def is_username_at?(text)
      text[0]=='@' and is_username?(text)
    end
    
    def is_username?(text)
      text[1..-1] == text[USERNAME_REGEX]
    end
    def sex_options
      ['Masculino','Feminino']
    end
  end
    



  #EVENTS

  before_create do
    self.cached_photo_url = UserPhoto.new.image.url
  end

  after_create do
    recount_relations
  end
  
  
  alias :u_ :username_at
  alias :fn_ :fullname
  def p_
    self.attributes['cached_photo_url'] || photo.image.url(:thumb)
  end
  
end
