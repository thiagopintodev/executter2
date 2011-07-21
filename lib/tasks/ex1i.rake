namespace :ex1i do

  desc "brings users from executter.com ex0"
  task :users => :environment do
    count = User.count
    1000.times do |i|
      skip = i*1000
      next if skip < count*0.9
      puts url = "http://executter.com/pure/users?skip=#{skip}"
      content = open(url).read
      users = JSON.load(content)
      break if users.empty?
      users.each do |user|
        u = user["user"]
        website = u['website'][0..196] if u['website']
        bio = u['description'][0..196] if u['description']
        
        u2 = User.new :username => u['username'],
                      :email    => u['email'],
                      :password_salt      => u['password_salt'],
                      :password_digest => u['encrypted_password'],
                      :sex      => u['gender'],
                      :born_at  => u['birth'],
                      :bio      => bio,
                      :created_at => u['created_at'],
                      :authentication_token => 'imported_from_ex1',
                      :locale     => u['locale'].try(:downcase),
                      #:time_zone  => u['time_zone'],
                      :website    => website
        names = u['full_name'].split(' ')
        u2.first_name = names.first || "Nome"
        u2.last_name  = names.last || "Sobrenome"
        puts "#{u2.username_at}\t\t\tsave: #{u2.save}"
      end
    end
    puts 'done'
  end

  desc "brings user photos from executter.com ex0"
  task :photos => :environment do
    count = Relation.count
    1000.times do |i|
      skip = i*1000
      #next if skip < count #must be a sequence
      puts url = "http://executter.com/pure/photos?skip=#{skip}"
      content = open(url).read
      photos = JSON.load(content)
      break if photos.empty?
      photos.each do |photo|
        p = photo["photo"]
        u = User.findu(p["user_username"])
        next unless u
        begin
          url = URI.escape(p['url'])
          file = open(url)
          p1 = u.user_photos.new :image => file
          p1.image_file_name=p['filename']
          
          u.update_attribute(:user_photo_id, p1.id) if p1.save
          
          puts "#{p1.id} \t @#{u.username}"
        rescue
          puts "error \t @#{u.username}"
        end
      end
    end
    puts 'done'
  end
  
  desc "brings user relations from executter.com ex0"
  task :relations => :environment do
    count = Relation.count
    1000.times do |i|
      skip = i*1000
      next if skip < count*0.999
      puts url = "http://executter.com/pure/relationships?skip=#{skip}"
      content = open(url).read
      relationships = JSON.load(content)
      break if relationships.empty?
      relationships.each do |re|
        r = re["relationship"]
        u1, u2 = User.findu(r["user1_username"]), User.findu(r["user2_username"])
        next unless u1 and u2
        r2 = Relation.new   :user_id  => u1.id,
                            :user2_id => u2.id,
                            :is_follower => r["is_follower"],
                            :is_followed => r["is_followed"]
                     
        puts "#{r2.save} \t @#{r['user1_username']} \t\t @#{r['user2_username']}"
        
      end
    end
    puts "recounting relations now"
    User.all.collect &:recount_relations
    puts 'done'
  end

  desc "brings user posts from executter.com ex0"
  task :posts => :environment do
    1000.times do |i|
      puts url = "http://executter.com/pure/posts?last_post_id=#{Post.last.try(:post_id) || 0}"
      content = open(url).read
      posts = JSON.load(content)
      break if posts.empty?
      
      posts.each do |post|
        p = post["post"]
        u = User.findu(p["user_username"])
        next unless u

        p1 = u.posts.new  :remote_ip  => p["remote_ip"],
                          #:is_comment => true,
                          :body       => p["body"],
                          :post_id    => p["id"],
                          :created_at => p["created_at"],
                          :files_categories => Post::CATEGORY_STATUS
                          
        p1.save
          puts "post #{p1.id} :)"
        unless p["url"]
          puts "post #{p1.id} :)"
        else
          #begin
          
            filename = p["filename"]
            url = URI.escape(p["url"])
            
            files_extensions = filename.split('.').last
            
            file = open(url)
            #
            pf=nil
            if ["jpg", 'gif','png','bmp'].include? files_extensions
              pf = p1.post_files.new( :image => file,
                                      :category=>Post::CATEGORY_IMAGE,
                                      :extension=>files_extensions,
                                      :filename=>filename)
              puts "post #{p1.id}:#{pf.save} image #{u.username_at}"
            elsif ["mp3"].include? files_extensions
              pf = p1.post_files.new( :audio => file,
                                      :category=>Post::CATEGORY_AUDIO,
                                      :extension=>files_extensions,
                                      :filename=>filename)
              puts "post #{p1.id}:#{pf.save} audio #{u.username_at}"
            else
              pf = p1.post_files.new( :other => file,
                                      :category=>Post::CATEGORY_OTHER,
                                      :extension=>files_extensions,
                                      :filename=>filename)
              puts "post #{p1.id}:#{pf.save} other #{u.username_at} #{url}"
            end
            p1.update_attribute :files_categories, pf.category
            #
          #rescue NoMethodError => e
          #  puts "post #{p1.id} no method"
          #  #p1.update_attribute :has_status,true
          #rescue => e
          #  puts "post #{p1.id}, file: #{e.class.name} #{e} -- #{url}"
          #  #p1.update_attribute :has_status,true
          #end
        end
      end
    end
    puts 'done'
    puts Post.update_all(:post_id=>nil)
    Post.all.map &:create_words
  end

end
