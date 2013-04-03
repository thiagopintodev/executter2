class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :username
      t.boolean :email_confirmed,     :default=>false
      t.boolean :username_confirmed,  :default=>false
      #t.string :password -- view generation purpose
      t.string :password_digest
      t.string :password_salt
      t.string :authentication_token
      t.integer :user_photo_id
      t.integer :user_theme_id
      #t.string :validation_token


      t.string :privileges_string
      t.string :relations_count_string
      t.string :posts_count_string
      
      t.integer :likes_count,   :default=>0
      #t.string :posts_count_hash
      #t.integer :user_photos_count,   :default=>0
      #t.integer :user_backgrounds_count,   :default=>0
      #t.integer :invites_count,   :default=>0
      #t.datetime :last_click_at
      t.string :bio
      t.string :website
      t.string :first_name
      t.string :last_name
      t.integer :sex,           :default=>0
      t.date    :born_at
      #t.integer :sex_policy,    :default=>0
      #t.integer :born_policy,   :default=>0
      t.boolean :likes_male,    :default=>false
      t.boolean :likes_female,  :default=>false
      #t.string :time_zone
      t.string :locale
      #t.integer :user_id_inviter
      #cities
      #cities
      #cities
      #cities
      #cities
      #cities
      #cities

      t.timestamps
    end
    
    add_index :users, [:email]
    add_index :users, [:username]
    
    add_index :users, [:id, :email]
    add_index :users, [:id, :username]
  end

  def self.down
    drop_table :users
  end
end
