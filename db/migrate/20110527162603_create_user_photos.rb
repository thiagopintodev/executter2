class CreateUserPhotos < ActiveRecord::Migration
  def self.up
    create_table :user_photos do |t|
      t.integer :user_id

      t.timestamps
    end
  end

  def self.down
    drop_table :user_photos
  end
end
