namespace :ex2 do
  desc "caches all users main photo into user model"
  task :cache_photos => :environment do
    User.update_all :cached_photo_url => UserPhoto.new.image.url(:thumb)

    user_ids = UserPhoto.select("DISTINCT(user_id)").map(&:user_id)
    
    User.find(user_ids).each do |u|
      if u.user_photo
        u.update_attribute :cached_photo_url, u.user_photo.image.url(:thumb)
      end
    end
    puts 'done'
  end
  
  task :words, [:i] => [:environment] do |t, args|
    10000.times do
      Post.where(:generated_words=>false).limit(10).offset(args[:i]).map &:create_words
    end
  end
  task :words, [:i] => [:environment] do |t, args|
    10000.times do
      Post.where(:generated_notifications=>false).limit(10).offset(args[:i]).each &:assign_notifications
    end
  end
  
end
