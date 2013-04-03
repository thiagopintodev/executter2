class CreatePostFollowers < ActiveRecord::Migration
  def self.up
    create_table :post_followers do |t|
      t.integer :post_id
      t.integer :user_id
      t.string :reason

      t.timestamps
    end
  end

  def self.down
    drop_table :post_followers
  end
end
