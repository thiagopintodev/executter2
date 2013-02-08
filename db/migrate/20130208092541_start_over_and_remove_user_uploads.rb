class StartOverAndRemoveUserUploads < ActiveRecord::Migration
  def self.up
    #UserTheme.find_each(&:destroy)
    #user_theme_id: nil, 
    UserPhoto.find_each(&:destroy)
    User.update_all user_photo_id: nil, cached_photo_url: UserPhoto.new.image.url
    Post.where("image_file_name is not null").find_each { |p| p.image=nil && p.save! }
  end

  def self.down
  end
end
