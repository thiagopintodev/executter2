class CreatePostMentions < ActiveRecord::Migration
  def self.up
    create_table :post_mentions do |t|
      t.integer :post_id
      t.string :value

      t.timestamps
    end
    add_index :post_mentions, :value
  end

  def self.down
    drop_table :post_mentions
  end
end
