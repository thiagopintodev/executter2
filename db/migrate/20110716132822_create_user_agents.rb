class CreateUserAgents < ActiveRecord::Migration
  def self.up
    create_table :user_agents do |t|
      t.string :key
      t.integer :count, :default => 1

      t.timestamps
    end
    add_index :user_agents, [:key]
  end

  def self.down
    drop_table :user_agents
  end
end
