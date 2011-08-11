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
  
  def recount_posts
    h = { :all      => posts.count,
          :status   => posts.only_status.count,
          :images   => posts.only_images.count,
          :audios   => posts.only_audios.count,
          :others   => posts.only_others.count,
          :mentions => Post.mentions_count(u_)
        }
    update_attribute :posts_count_string, h.collect { |k,v| "#{k}:#{v}" }.join(',')
    @pch = nil
    posts_count_hash
  end

  def pch
    posts_count_hash || recount_posts
  end

  #privileges array
  def privileges
    privileges_string.split(',')
  end
  def privileges=(value)
    privileges_string = value.join(',')
  end
  def developer?
    false
  end
  def admin?
    false
  end

  
end
