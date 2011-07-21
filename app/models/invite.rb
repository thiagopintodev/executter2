class Invite < ActiveRecord::Base
  belongs_to :user
  
  validates :user_id,
    :presence => true
  validates :email_to,
    :presence => true
  validate :token,
    :unique => true
    
  before_save :generate_token

  def generate_token
    self.token = MyF.md5 "#{user_id} #{email_to}"
  end
  
end
