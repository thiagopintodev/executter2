class PostFollower < ActiveRecord::Base
  belongs_to :user
  belongs_to :post
  #reason:string
  
end
