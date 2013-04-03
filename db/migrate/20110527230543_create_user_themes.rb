class CreateUserThemes < ActiveRecord::Migration
  def self.up
    create_table :user_themes do |t|
      t.integer :user_id
      t.string :flavour
      t.string :background_color, :default=>'#ffffff'
      t.integer :background_repeat

      t.timestamps
    end
  end

  def self.down
    drop_table :user_themes
  end
end
