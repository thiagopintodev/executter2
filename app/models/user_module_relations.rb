module UserModuleRelations

  def self.included(base)
    #base.extend ClassMethods
    base.class_eval do
      has_many :relations,  :dependent => :destroy
      has_many :followers,  :class_name => "Relation",# :foreign_key => :user_id,
                            :conditions => {:is_followed=>true}
      has_many :followings, :class_name => "Relation", #:foreign_key => :user_id,
                            :conditions => {:is_follower=>true}
      has_many :friends,    :class_name => "Relation", :foreign_key => :user_id,
                            :conditions => {:is_follower=>true, :is_followed=>true}
    end
  end
  
  #module ClassMethods
  #end

  def relate(user2_id, type)
    Relation.relate_users(self, user2_id, type)
  end
  def is_following?(user2_id)
    Relation.is_following?(self, user2_id)
    #will be useful
    #followings.select(:user2_id).collect(&:user2_id).include?(user2_id)
  end



  #relation user ids
  def followers_user_ids
    followers.select(:user2_id).map(&:user2_id)
  end
  #relation user ids
  def followings_user_ids
    followings.select(:user2_id).map(&:user2_id)
  end
  #relation user ids
  def friends_user_ids
    friends.select(:user2_id).map(&:user2_id)
  end



  #segmented relations load
  def followers_users
    User.find followers_user_ids
  end
  #segmented relations load
  def followings_users
    User.find followings_user_ids
  end
  #segmented relations load
  def friends_users
    User.find friends_user_ids
  end


  
  #read-only
  def followers_users_ro
    User.kv_find followers_user_ids
  end
  #read-only
  def followings_users_ro
    User.kv_find followings_user_ids
  end
  #read-only
  def friends_users_ro
    User.kv_find friends_user_ids
  end
  
end
