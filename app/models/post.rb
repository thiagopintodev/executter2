class Post < ActiveRecord::Base

  Paperclip.interpolates :transliterated_filename do |attachment, style|
    ActiveSupport::Inflector.transliterate(attachment.original_filename.downcase)
  end

  def self.paperclip_options(styles={})
    r = {}
    r[:default_url] = "/images/default/:class_:attachment/:style.png"
    r[:styles] = styles
    path = "/#{My.my_env}/:class_:attachment/:id_partition/:transliterated_filename"
    
    if My.production?
      r[:storage] = :s3
      r[:s3_credentials] = MyConfig.get_aws_credentials
      r[:bucket] = "executter.com"
      r[:path] = path
    else
	    r[:path] = ":rails_root/public/assets#{path}"
	    r[:url] = "/assets#{path}"
    end
    r
  end
  
  has_attached_file :image, paperclip_options({ :original=>["700x2800>", :jpg] })
  
  belongs_to :user#, :counter_cache=>false --> using a hash
  belongs_to :post, :counter_cache=>true  #kind of needs a hash here
  belongs_to :user_info, :foreign_key => "user_id"
  has_many :posts,      :dependent => :destroy
  has_many :likes,      :dependent => :destroy
  has_many :post_words#, :dependent => :destroy
  
  has_many :likes_users, :through => :likes, :source=>:user
  
  
  has_many :post_followers, :dependent => :destroy
  has_many :post_user_news, :dependent => :destroy

  validates :body, :presence => true, :length => { :within => 1..200 }
  validates :user_id, :presence=>true
  validates :placement, :presence=>true
  #validates :files_categories, :presence=>true
  
  before_validation do
    return true unless new_record?
    
    if self.post_id
      self.on_timeline = false
      self.placement = PLACEMENT_COMMENT
    else
      self.on_timeline = true
      self.placement = PLACEMENT_TOPIC
    end
  end
  
  validate do
    errors.add(:placement, "a comment must have a parent") if !!post_id && !comment?
  end

  def to_param
    "#{self.id}-#{self.cached_body.gsub(/[\W]/, '-')}"
  end

  #forces 196
  before_create do
    self.body = self.body[0..195]
  end
  before_destroy do
    PUN.delete_all(:post_id=>self.id)
    PostWord.delete_all(:post_id=>self.id)
  end



  def i_
    @i_ ||= self.link_url || self.image? and self.image.url(:original, false)
  end





  


  attr_accessor :is_repost
  
  def comment?
    [PLACEMENT_COMMENT, PLACEMENT_REPOST].include? placement
  end
  def topic?
    [PLACEMENT_TOPIC].include? placement
  end
  def repost?
    [PLACEMENT_REPOST].include? placement
  end

  

  #CONSTANTS
  DEFAULT_LIMIT = 10
  DEFAULT_COMMENT_LIMIT = 3
  WORD_REGEX_NOT = /[^\w@#\$]/
  #WORD_REGEX_NOT = /[^\w@]/

  
  CATEGORY_STATUS= "status"
  CATEGORY_IMAGE = "image"
  CATEGORY_AUDIO = "audio"
  CATEGORY_OTHER = "other"
  
  PLACEMENT_TOPIC     = "topic"
  PLACEMENT_COMMENT   = "comment"
  PLACEMENT_REPOST    = "repost"
  PLACEMENT_AUTOMATIC = "automatic"


  REASON_MENTIONED  = 'mentioned'
  REASON_CREATED    = 'created'
  REASON_LIKED      = 'liked'
  REASON_COMMENTED  = 'commented'
  REASON_REPOSTED   = 'reposted'
  REASON_NEW_FOLLOWER = 'new_follower'

  ORIGIN_MOBILE = 'mobile'
  ORIGIN_WEB    = 'web'
=begin
  REASONS = [
    REASON_MENTIONED,
    REASON_CREATED,
    REASON_LIKED,
    REASON_COMMENTED,
    REASON_REPOSTED
  ]
=end


  #default_scope :limit => 5, :order => "ID desc"
  scope :as_a_result, limit(DEFAULT_LIMIT).order("id DESC")
  
  scope :after, lambda { |id| id ? where("posts.id > ?", id) : scoped }
  scope :before, lambda { |id| id ? where("posts.id < ?", id) : scoped }


  scope :select_cacheable_fields,   select(['id','body'])
  scope :select_uncacheable_fields, select(['id', "user_id", "post_id", "placement", "on_timeline", "files_categories", "files_extensions", "generated_notifications", "remote_ip", "origin", "likes_count", "posts_count", "post_files_count", "created_at", "updated_at",
"image_file_name", "image_content_type", "image_file_size", "image_updated_at", "link_url"])

    
    



  scope :only_status, where(:files_categories=>CATEGORY_STATUS)
  scope :only_images, where(:files_categories=>CATEGORY_IMAGE)
  scope :only_audios, where(:files_categories=>CATEGORY_AUDIO)
  scope :only_others, where(:files_categories=>CATEGORY_OTHER)
#  scope :only_status, where(:has_status=>true)


  #scope :mentioned, lambda { |username| where("usernames LIKE ?", "% #{username.downcase} %") }

  def likes?(user_id)
    Likes.likes?(user_id, self.id)
  end

  def like_it(user_id_liker)
    Like.like_it(user_id_liker, id)
  end

  after_create do
    create_words
    assign_notifications
  end

  def assign_notifications
    #my_post_news = []
    my_post_followers = []
    #assign mentioned users to be notified for future events
    #notify mentioned users to this event (being mentioned)
    post_words.only_usernames.each do |word|
      next unless user_mentioned = User.findu(word.word.delete('@'))
      
      #assigns user to this post
      my_post_followers << pfo = PFo.find_or_create_by_user_id_and_post_id(user_mentioned.id, id)
      #as he was mentioned, that's why he gets an email per comment/like on a post he's been mentioned
      pfo.reason = Post::REASON_MENTIONED
      #this means we asure the mentioned user has been sent an email about his being mentioned
      #pn.email_sent   = true

      #this means for how long we're going to be mailing this user for events to this post addressed to this reason
      #pn.email_expires_at         = 10.years.from_now
      #pn.notification_expires_at  = 10.years.from_now
      
      #actually notes the sending of the email
      next if My.production? && user_mentioned.id == user.id
      
      PUN.create! :user_id_from   => user.id,
                  :user_id        => user_mentioned.id,
                  :post_id        => id,
                  :reason_trigger => Post::REASON_CREATED,  # someone created a post
                  :reason_why     => Post::REASON_MENTIONED # I relate to it because I was mentioned at it
    end

    #if this is a comment, we have to notify every user on the post_followers list

    if comment?
      post.post_followers.each do |pfo|
        next if pfo.user_id == user.id
        #actually notes the sending of the email
        PUN.create! :user_id_from   => user.id,
                    :user_id        => pfo.user_id,
                    :post_id        => post_id,
                    :reason_trigger => Post::REASON_COMMENTED,  # someone created a post
                    :reason_why     => pfo.reason # how I relate to it
      end#each
    end
    
    #assigns (or updates) user to be notified, either to THIS or PARENT post
    if comment?
      #assigns this user to receive a message when there are events to   PARENT   post, because...
      #my_post_news << pn = PostNews.find_or_create_by_user_id_and_post_id(user.id, post_id)
      my_post_followers << pfo = PFo.find_or_create_by_user_id_and_post_id(user.id, post_id)
      #user has commented on   PARENT   post
      #pn.send(repost? ? "has_reposted=" : "has_commented=", true)
      pfo.reason = repost? ? Post::REASON_REPOSTED : Post::REASON_COMMENTED
      
      #unless pn.has_created#user can comment his own post and still receive notifications for the same time
      #  pn.email_expires_at         = 07.days.from_now
      #  pn.notification_expires_at  = 30.days.from_now
      #end
    else#is a topic
      #assigns this user to receive a message when there are events to   THIS   post, because...
      #my_post_news << pn = PostNews.find_or_create_by_user_id_and_post_id(user.id, id)
      my_post_followers << pfo = PFo.find_or_create_by_user_id_and_post_id(user.id, id)
      #... this user has created   THIS   post
      #pn.has_created = true
      pfo.reason = Post::REASON_CREATED
      #pn.email_expires_at         = 10.years.from_now
      #pn.notification_expires_at  = 10.years.from_now
    end
    #FALTA LIKED
    #FALTA LIKED
    #FALTA LIKED
    #FALTA LIKED
    
    #my_post_news.collect &:save!
    my_post_followers.collect &:save!
    
    update_attribute :generated_notifications, true
    #save
  end
  
  #optimize_word_search
  def create_words
    text = body.gsub(WORD_REGEX_NOT, ' ').downcase
    
    words = text.split(' ')
    words.uniq!
    if My.pg?
      inserts = []
      words.each { |word| inserts.push(Post.send(:sanitize_sql_array, ["(?, ?)", self.id, word])) if word.length >= 3 }
      sql = "INSERT INTO \"post_words\" (\"post_id\", \"word\") VALUES #{inserts.join(', ')}"
      #transaction {  }
      connection.execute(sql) if inserts.size > 0
      #INSERT INTO "post_words" ("post_id", "word") VALUES (3, 'aaaaaaaaaaaaaaa')
    else
      words.each { |word| post_words.create!(:word=>word) if word.length >= 3 }
    end
    update_attribute :generated_words, true
    true
  end

  def cached_body
    return self.attributes['body'] ||= Post.kv_find_id(self.id).body
  end

  
  #SEARCH METHODS
  class << self
    def kv_find_id(id)
      return nil unless id
      #puts "****** POST '#{id}' from KEY VALUE STORE"
      r = Rails.cache.read([:model, :post_kv, id])
      unless r
        r = where(:id=>id).limit(1).select_cacheable_fields.first
        Rails.cache.write([:model, :post_kv, id], r, :expires_in=>10.minutes) rescue true if r
      end
      r
    end
    
    def from_relation_count_unread(user, source)
      user = User.find(user) unless user.is_a? User

      user_ids = nil
      user_ids = user.followers_user_ids   if source == :followers
      user_ids = user.followings_user_ids  if source == :followings
      user_ids = user.friends_user_ids     if source == :friends
      user_ids << user.id
      
      posts = Post.where(:user_id=>user_ids)
                  .where("on_timeline = ?", true)
                  .after(user.last_read_post_id)
                  .limit(10)
      posts.count
    end
    
    def from_relation(user, source, options={})
      user = User.find(user) unless user.is_a? User

      user_ids = nil
      user_ids = user.followers_user_ids   if source == :followers
      user_ids = user.followings_user_ids  if source == :followings
      user_ids = user.friends_user_ids     if source == :friends
      user_ids << user.id
      
      posts = Post.where(:user_id=>user_ids)
                  .where("on_timeline = ?", true)
                  .before(options[:before])
                  .after(options[:after])
                  .as_a_result
                  
      posts = posts.where(:files_categories=>options[:filter]) if options[:filter]
      posts.select_uncacheable_fields
    end

    def from_profile(user, options={})
      user = User.find(user) unless user.is_a? User
                        #.where("is_comment = ? OR is_repost = ?", false, true)
      posts = user.posts.where("on_timeline = ?", true)
                        .before(options[:before])
                        .as_a_result
      posts = posts.where(:files_categories=>options[:filter]) if options[:filter]
      posts.select_uncacheable_fields
    end
    
    def from_search(text, options={})
      #TODO: options[:post_type]
      #TODO: options[:post_type_detail] jpg|gif|pdf|doc|ppt simplify table, string column instead of booleans, booleans are good for multiple file cases
      return [] unless text
      words = text.downcase.split(' ')
      
      post_ids = PostWord.select('DISTINCT post_id')
                         .where(:word=>words)
                         .before(options[:before])
                         .after(options[:after])
                         .limit(DEFAULT_LIMIT)
                         .collect(&:post_id)

      Post.where(:id=>post_ids)
          .order("id DESC")
          .select_uncacheable_fields
    end

    def mentions_count(username_at)
      PostWord.select('DISTINCT post_id')
              .where(:word=>username_at.downcase)
              .count
    end
  end
end
=begin
  create_table "posts", :force => true do |t|
    t.integer  "user_id"
    t.integer  "post_id"
    t.string   "placement"
    t.boolean  "on_timeline",             :default => true
    t.string   "files_categories",        :default => "status"
    t.string   "files_extensions"
    t.boolean  "generated_notifications", :default => false
    t.string   "body"
    t.string   "remote_ip",               :default => "-"
    t.integer  "likes_count",             :default => 0
    t.integer  "posts_count",             :default => 0
    t.integer  "post_files_count",        :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "generated_words",         :default => false
  end

  add_index "posts", ["post_id"], :name => "index_posts_on_post_id"
  add_index "posts", ["user_id", "on_timeline"], :name => "index_posts_on_user_id_and_on_timeline"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"
=end
