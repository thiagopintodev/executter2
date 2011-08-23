class CreateCityBases < ActiveRecord::Migration
  def self.up
    create_table :city_bases do |t|
      t.string :country
      t.string :name
      t.string :label
      t.string :region
      t.string :data
      t.integer :population
      t.decimal :lat
      t.decimal :lng

      t.timestamps
    end
  end

  def self.down
    drop_table :city_bases
  end
end
