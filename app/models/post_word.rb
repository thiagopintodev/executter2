class PostWord < ActiveRecord::Base
  belongs_to :post
  scope :only_usernames, where("word LIKE '@%'")
  
  scope :after, lambda { |id| id ? where("post_words.post_id > ?", id) : scoped }
  scope :before, lambda { |id| id ? where("post_words.post_id < ?", id) : scoped }

  default_scope order("post_id DESC")
end
