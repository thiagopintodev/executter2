class BetterIndexPostWords < ActiveRecord::Migration
  def self.up
    add_index :post_words, [:post_id, :word]
  end

  def self.down
    remove_index :post_words, [:post_id, :word]
  end
end
