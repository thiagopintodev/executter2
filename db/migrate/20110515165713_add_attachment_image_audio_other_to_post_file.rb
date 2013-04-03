class AddAttachmentImageAudioOtherToPostFile < ActiveRecord::Migration
  def self.up
    add_column :post_files, :image_file_name, :string
    add_column :post_files, :image_content_type, :string
    add_column :post_files, :image_file_size, :integer
    add_column :post_files, :image_updated_at, :datetime
    add_column :post_files, :audio_file_name, :string
    add_column :post_files, :audio_content_type, :string
    add_column :post_files, :audio_file_size, :integer
    add_column :post_files, :audio_updated_at, :datetime
    add_column :post_files, :other_file_name, :string
    add_column :post_files, :other_content_type, :string
    add_column :post_files, :other_file_size, :integer
    add_column :post_files, :other_updated_at, :datetime
  end

  def self.down
    remove_column :post_files, :image_file_name
    remove_column :post_files, :image_content_type
    remove_column :post_files, :image_file_size
    remove_column :post_files, :image_updated_at
    remove_column :post_files, :audio_file_name
    remove_column :post_files, :audio_content_type
    remove_column :post_files, :audio_file_size
    remove_column :post_files, :audio_updated_at
    remove_column :post_files, :other_file_name
    remove_column :post_files, :other_content_type
    remove_column :post_files, :other_file_size
    remove_column :post_files, :other_updated_at
  end
end
