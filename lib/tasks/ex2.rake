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
  
  task :recount_user_mentions, [:i] => [:environment] do |t, args|
    User.all.map &:recount_posts_mentions
  end
  
end
