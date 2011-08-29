class RemakeUserCityId < ActiveRecord::Migration
  def self.up
    remove_column :users, :city_id
    add_column :users, :born_city_id, :integer
    add_column :users, :living_city_id, :integer
  end

  def self.down
    add_column :users, :city_id, :integer
    remove_column :users, :born_city_id
    remove_column :users, :living_city_id
  end
end
