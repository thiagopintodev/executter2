class CreateRelations < ActiveRecord::Migration
  def self.up
    create_table :relations do |t|
      t.integer :user_id
      t.integer :user2_id
      t.boolean :is_follower
      t.boolean :is_followed
=begin
      t.boolean :is_follow_requester
      t.boolean :is_follow_requested
      t.boolean :is_status_requester
      t.boolean :is_status_requested
      t.string :status_request_args
=end
      t.timestamps
    end
  end

  def self.down
    drop_table :relations
  end
end
