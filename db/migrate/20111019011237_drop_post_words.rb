class DropPostWords < ActiveRecord::Migration
  def self.up
    drop_table :post_words
  end

  def self.down
    create_table "post_words", :id => false, :force => true do |t|
      t.integer "post_id"
      t.string  "word"
    end

    add_index "post_words", ["post_id", "word"], :name => "index_post_words_on_post_id_and_word"
    add_index "post_words", ["post_id"], :name => "index_post_words_on_post_id"
    add_index "post_words", ["word"], :name => "index_post_words_on_word"
  end
end
