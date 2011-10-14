class AddAttachmentImageToPost < ActiveRecord::Migration
  def self.up
    add_column :posts, :image_file_name, :string
    add_column :posts, :image_content_type, :string
    add_column :posts, :image_file_size, :integer
    add_column :posts, :image_updated_at, :datetime
    add_column :posts, :link_url, :string
    PostFile.all.each do |pf|
      pf.post.update_attribute(:link_url, pf.image.url(:original, false))
    end
  end

  def self.down
    remove_column :posts, :image_file_name
    remove_column :posts, :image_content_type
    remove_column :posts, :image_file_size
    remove_column :posts, :image_updated_at
    remove_column :posts, :link_url, :string
  end
end
