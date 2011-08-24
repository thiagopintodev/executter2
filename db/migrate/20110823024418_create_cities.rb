class CreateCities < ActiveRecord::Migration
  def self.up
    create_table :cities do |t|
      t.references :city_base
      t.references :city
      t.string :name
      t.string :label
      t.string :country

      t.timestamps
    end
    add_index :city_bases, :label
  end

  def self.down
    drop_table :cities
  end
end
