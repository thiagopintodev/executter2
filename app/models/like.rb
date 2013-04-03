class Like < ActiveRecord::Base
  belongs_to :user, :counter_cache=>true
  belongs_to :post, :counter_cache=>true

  class << self
    def like_it(user_id, post_id)
      create :user_id=>user_id, :post_id=>post_id unless likes? user_id, post_id
    end
    def likes?(user_id, post_id)
      exists? :user_id=>user_id, :post_id=>post_id
    end
  end

  def assign_notifications
    #my_post_news = []
    #TODO: assign mentioned users to be notified for future events


    #actually notes the sending of the email
    unless post.user_id == user_id
      DelayiedEmailNews.create! :user_id_from => user_id,
                                :user_id_to   => post.user_id,
                                :post_id      => post_id,
                                :comment_id   => nil,
                                :main_reason  => DelayiedEmailNews::LIKED_ON_POST_I_CREATED
    end
    update_attribute :generated_notifications, true
    #save
  end
  
end
