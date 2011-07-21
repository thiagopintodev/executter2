class Relation < ActiveRecord::Base

  belongs_to :user
  belongs_to :user2, :class_name => "User", :foreign_key => "user2_id"
  validates :user_id, :presence => true
  validates :user2_id, :presence => true
  
  validate :cant_relate_to_self
  validate :unique_relation, :on => :create


  def is_friend?
    is_follower and is_followed
  end
  
  #serialize :status_request_args
  #before_create :my_before_create
  
  #def my_before_create
  #  self.ignored_subjects = [] if self.ignored_subjects == nil
  #end
  
  def cant_relate_to_self
    errors.add(:user_id, "one can't make a relationship with themselves") if user_id == user2_id
  end

  def unique_relation
    errors.add(:user_id, "this relation already exists") if Relation.exists?(:user_id=>user_id, :user2_id=>user2_id)
  end

  class << self
    def is_following?(user1, user2)
      exists?(:user_id=>user1, :user2_id=>user2, :is_follower=>true)
    end
    def relate_users(user1, user2, type)
      user1 = User.find(user1) unless user1.is_a? User
      user2 = User.find(user2) unless user2.is_a? User
      case type.to_s
         when 'follow'    then relate_users_follow(user1, user2, true)
         when 'unfollow'  then relate_users_follow(user1, user2, false)
         when 'auto_friends'   then relate_users_friends(user1, user2, true)
         #when '' then result3
         #when match4 then result4
         #when match5 then result5
         #when match6 then result6
         else false
      end
    end

    def relate_users_follow(user1, user2, value)
      rr = my_find_both(user1.id, user2.id)
      r1, r2 = rr[:r1], rr[:r2]
      #transaction-begin
      r1.is_follower = r2.is_followed = value
      return false unless r1.save && r2.save
      PUN.create! :user_id_from   => user1.id,
                  :user_id        => user2.id,
                  :post_id        => nil,
                  :reason_trigger => Post::REASON_NEW_FOLLOWER,  # someone created a post
                  :reason_why     => Post::REASON_NEW_FOLLOWER # I relate to it because I have a new follower
      
      #transaction-end
#      DelayedMailFollowed.create(:user_id=>r1.user2_id, :follower_user_id=>r1.user1_id) if (didnt_follow and now_follows)
      true
    end

    def relate_users_friends(user1, user2, value)
      rr = my_find_both(user1.id, user2.id)
      r1, r2 = rr[:r1], rr[:r2]
      #transaction-begin
      r1.is_follower = r2.is_followed = value
      r1.is_followed = r2.is_follower = value
      return false unless r1.save && r2.save
      PUN.create! :user_id_from   => user1.id,
                  :user_id        => user2.id,
                  :post_id        => nil,
                  :reason_trigger => Post::REASON_NEW_FOLLOWER,  # someone created a post
                  :reason_why     => Post::REASON_NEW_FOLLOWER # I relate to it because I have a new follower
      
      #transaction-end
#      DelayedMailFollowed.create(:user_id=>r1.user2_id, :follower_user_id=>r1.user1_id) if (didnt_follow and now_follows)
      true
    end
    
    private
    def my_find_both(u1, u2)
      #gotta check witch line below is faster
      #ar = where("(user1_id=:user1 AND user2_id=:user2) OR (user1_id=:user2 AND user2_id=:user1)", :user1=>user1_id, :user2=>user2_id)
      #ar = where("user_id IN (:a) AND user2_id IN (:a)", :a=>[u1, u2]).limit(2)
      ar = where(:user_id=>[u1, u2], :user2_id=>[u1, u2]).limit(2)
      
      rr = {}
      ar.each { |a| rr[ (a.user_id == u1) ? :r1 : :r2 ] = a }
      rr[:r1] = new(:user_id=>u1, :user2_id=>u2) unless rr[:r1]
      rr[:r2] = new(:user_id=>u2, :user2_id=>u1) unless rr[:r2]
      rr
      #returns objects not saved to the database if the relationship does not exist
    end
  end
end
