class CreateInvites < ActiveRecord::Migration
  def self.up
    create_table :invites do |t|
      t.integer :user_id
      t.string :email_to
      t.string :name_to
      t.string :token

      t.timestamps
    end
    add_index :invites, [:user_id]
    add_index :invites, [:email_to]
    add_index :invites, [:token]
  end

  def self.down
    drop_table :invites
  end
end
