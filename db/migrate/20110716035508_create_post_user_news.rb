class CreatePostUserNews < ActiveRecord::Migration
  def self.up
    create_table :post_user_news do |t|
      t.integer :post_id
      t.integer :user_id
      t.integer :user_id_from
      t.string :reason_trigger
      t.string :reason_why
      t.boolean :is_read,   :default=>false
      t.boolean :is_mailed, :default=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :post_user_news
  end
end
