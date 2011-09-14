class CreateMyConfigs < ActiveRecord::Migration
  def self.up
    create_table :my_configs do |t|
      t.string :key
      t.string :val

      t.timestamps
    end
  end

  def self.down
    drop_table :my_configs
  end
end
