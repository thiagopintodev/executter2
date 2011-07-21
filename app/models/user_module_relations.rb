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

      has_many :followers_users,  :through => :followers,  :source => :user2
      has_many :followings_users, :through => :followings, :source => :user2
      has_many :friends_users,    :through => :friends,    :source => :user2
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

  
end
