class CreateSmiles < ActiveRecord::Migration
  def self.up
    create_table :smiles do |t|
      t.string :key
      t.boolean :is_visible, :default=>false

      t.timestamps
    end
  end

  def self.down
    drop_table :smiles
  end
end
