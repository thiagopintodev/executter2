class CreatePostWords < ActiveRecord::Migration
  def self.up
    create_table :post_words, :id => false do |t|
      t.integer :post_id
      t.string :word
    end
    add_index :post_words, :word
  end

  def self.down
    drop_table :post_words
  end
end
