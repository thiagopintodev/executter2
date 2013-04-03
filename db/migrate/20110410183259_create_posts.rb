class CreatePosts < ActiveRecord::Migration
  def self.up
    create_table :posts do |t|
      t.integer :user_id
      t.integer :post_id
      t.string :placement
      t.boolean :on_timeline, :default => true
      #t.boolean :on_comments, :default => false
      t.string :files_categories,  :default => Post::CATEGORY_STATUS
      t.string :files_extensions#,  :default => nil
      t.boolean :generated_notifications, :default=>false
      t.string :body
      t.string :remote_ip,      :default=>'-'
      t.integer :likes_count,   :default=>0
      t.integer :posts_count,   :default=>0
      #t.string  :posts_hash_count#not sure yet
      t.integer :post_files_count,   :default=>0
=begin
      #t.boolean :is_automatic,  :default=>false
      #t.string :automatic_args
      #t.text :automatic_args
=end
      #t.boolean :has_status,    :default=>false
      #t.boolean :has_image,     :default=>false
      #t.boolean :has_audio,     :default=>false
      #t.boolean :has_other,     :default=>false
      #t.string :lat
      #t.string :lng
      #t.string :city_username
      #t.integer :city_id

      t.timestamps
    end
  end

  def self.down
    drop_table :posts
  end
end
