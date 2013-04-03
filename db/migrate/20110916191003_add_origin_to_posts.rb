class AddOriginToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :origin, :string, :default=>Post::ORIGIN_WEB
    Post.update_all :origin=>Post::ORIGIN_WEB
  end

  def self.down
    remove_column :posts, :origin
  end
end
