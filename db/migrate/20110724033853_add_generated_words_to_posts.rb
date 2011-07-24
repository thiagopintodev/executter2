class AddGeneratedWordsToPosts < ActiveRecord::Migration
  def self.up
    add_column :posts, :generated_words, :boolean, :default => false
  end

  def self.down
    remove_column :posts, :generated_words
  end
end
