class AddCachedPhotoUrlToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :cached_photo_url, :string
  end

  def self.down
    remove_column :users, :cached_photo_url
  end
end
