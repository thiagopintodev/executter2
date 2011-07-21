class PostWord < ActiveRecord::Base
  belongs_to :post
  scope :only_usernames, where("word LIKE '@%'")
end
