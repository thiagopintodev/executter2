class UserSession < ActiveRecord::Base
  belongs_to :user

  attr_accessor :key, :password
  
  validate :custom_validations

  def custom_validations
    #errors.add(:username, "username is not valid or is already taken") unless User.username_allowed username
  end

end
