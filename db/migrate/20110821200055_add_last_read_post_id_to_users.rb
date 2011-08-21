class AddLastReadPostIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :last_read_post_id, :integer
    User.update_all :last_read_post_id => Post.last.id
  end

  def self.down
    remove_column :users, :last_read_post_id
  end
end
