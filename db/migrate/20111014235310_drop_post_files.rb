class DropPostFiles < ActiveRecord::Migration
  def self.up
    drop_table :post_files
  end

  def self.down
    create_table "post_files", :force => true do |t|
      t.integer  "post_id"
      t.string   "filename"
      t.string   "category"
      t.string   "extension"
      t.integer  "count_of_downloads", :default => 0
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "image_file_name"
      t.string   "image_content_type"
      t.integer  "image_file_size"
      t.datetime "image_updated_at"
    end

    add_index "post_files", ["post_id"], :name => "index_post_files_on_post_id"
  end
end
