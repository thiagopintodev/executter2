class CreatePostFiles < ActiveRecord::Migration
  def self.up
    create_table :post_files do |t|
      t.integer :post_id
      t.string :filename
      t.string :category
      t.string :extension
      t.integer :count_of_downloads, :default=>0

      t.timestamps
    end
  end

  def self.down
    drop_table :post_files
  end
end
