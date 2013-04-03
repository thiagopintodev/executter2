class AddSeveralIndeces < ActiveRecord::Migration
  def self.up
    add_index :posts, [:user_id]
    add_index :posts, [:user_id, :on_timeline]
    add_index :posts, [:post_id]
    add_index :post_files, [:post_id]
    add_index :post_words, [:post_id]
    add_index :post_followers, [:user_id]
    add_index :post_followers, [:post_id]
    add_index :post_user_news, [:user_id]
    add_index :post_user_news, [:user_id, :is_read]
    add_index :post_user_news, [:user_id, :is_mailed]
    add_index :post_user_news, [:user_id, :is_read, :is_mailed]
    add_index :post_user_news, [:user_id_from]
    add_index :relations, [:user_id, :user2_id, :is_follower]
    add_index :relations, [:user_id, :user2_id, :is_followed]
    add_index :user_photos, [:user_id]
    add_index :user_themes, [:user_id]
  end

  def self.down
    remove_index :posts, [:user_id]
    remove_index :posts, [:user_id, :on_timeline]
    remove_index :posts, [:post_id]
    remove_index :post_files, [:post_id]
    remove_index :post_words, [:post_id]
    remove_index :post_followers, [:user_id]
    remove_index :post_followers, [:post_id]
    remove_index :post_user_news, [:user_id]
    remove_index :post_user_news, [:user_id, :is_read]
    remove_index :post_user_news, [:user_id, :is_mailed]
    remove_index :post_user_news, [:user_id, :is_read, :is_mailed]
    remove_index :post_user_news, [:user_id_from]
    remove_index :relations, [:user_id, :user2_id, :is_follower]
    remove_index :relations, [:user_id, :user2_id, :is_followed]
    remove_index :user_photos, [:user_id]
    remove_index :user_themes, [:user_id]
  end
end
