module UserModuleCustomize

  def self.included(base)
    #base.extend ClassMethods
    base.class_eval do
      has_many :user_photos,  :dependent => :destroy
      has_many :user_themes,  :dependent => :destroy
      belongs_to  :user_photo
      belongs_to  :user_theme
    end
  end
  
  #module ClassMethods
  #end

  def photo
    @user_photo ||= user_photo || user_photos.build
  end
  def theme
    @user_theme ||= user_theme || user_themes.build
  end



  #relations hash
  def rch
    relations_count_hash || recount_relations
  end
  
  def relations_count_hash
    return @rch if @rch
    return @rch = nil unless relations_count_string.present?
    r = {}
    relations_count_string.split(',').each do |element|
      k,v = element.split(':')
      r[k.to_sym]=v
    end
    @rch = r
  end
  
  def recount_relations
    h = { :followers  => followers.count,
          :followings => followings.count,
          :friends    => friends.count
        }
    update_attribute :relations_count_string, h.collect { |k,v| "#{k}:#{v}" }.join(',')
    @rch = nil
    relations_count_hash
  end

  #posts hash
  def posts_count_hash
    return @pch if @pch
    return @pch = nil unless posts_count_string.present?
    r = {}
    #posts_count_string.split(',').each { |k, v| @pch[k.to_sym]=v }
    posts_count_string.split(',').each do |element|
      k,v = element.split(':')
      r[k.to_sym]=v
    end
    @pch = r
  end

  #keep this method because it's the main resort for new users
  def recount_posts
    h = { :all      => posts.count,
          :mentions => Post.mentions_count(u_)
        }
    update_attribute :posts_count_string, h.collect { |k,v| "#{k}:#{v}" }.join(',')
    @pch = nil
    posts_count_hash
  end

  def pch
    posts_count_hash || recount_posts
  end

  def recount_posts_all
    #it was causing SELECT *, so I'm using this syntax now
    h = { :all      => Post.where(:user_id=>self.id).count,
          :mentions => pch[:mentions]
        }
    update_attribute :posts_count_string, h.collect { |k,v| "#{k}:#{v}" }.join(',')
  end

  def recount_posts_mentions
    h = { :all      => pch[:all],
          :mentions => Post.mentions_count(u_)
        }
    update_attribute :posts_count_string, h.collect { |k,v| "#{k}:#{v}" }.join(',')
  end
  
  #privileges array
  def privileges
    self.privileges_string.split(',') rescue []
  end
  def privileges=(value)
    self.privileges_string = value.join(',')
  end
  def developer?
    self.privileges.include?('dev')
  end
  def admin?
    self.privileges.include?('adm') || developer?
  end

  
end
