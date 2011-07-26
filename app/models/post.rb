class Post < ActiveRecord::Base
  belongs_to :user#, :counter_cache=>false --> using a hash
  belongs_to :post, :counter_cache=>true  #kind of needs a hash here
  belongs_to :user_info, :foreign_key => "user_id"
  has_many :posts,      :dependent => :destroy
  has_many :likes,      :dependent => :destroy
  has_many :post_words#, :dependent => :destroy
  has_many :post_files, :dependent => :destroy
  
  
  has_many :post_followers, :dependent => :destroy
  has_many :post_user_news, :dependent => :destroy

  validates :body, :presence => true, :length => { :within => 1..200 }
  validates :user_id, :presence=>true
  validates :placement, :presence=>true
  #validates :files_categories, :presence=>true
  
  before_validation do
    return true unless new_record?

    if !!self.post_id && !!self.is_repost
      #self.on_comments = true
      self.on_timeline = true
      self.placement = PLACEMENT_REPOST
    elsif !!self.post_id
      #self.on_comments = true
      self.on_timeline = false
      self.placement = PLACEMENT_COMMENT
    else
      #self.on_comments = false
      self.on_timeline = true
      self.placement = PLACEMENT_TOPIC
    end
  end
  
  validate do
    errors.add(:placement, "a comment must have a parent") if !!post_id && !comment?
  end


  #forces 196
  before_create do
    self.body = self.body[0..195]
  end
  before_destroy do
    PostWord.delete_all(:post_id=>self.id)
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
  DEFAULT_LIMIT = 25
  DEFAULT_COMMENT_LIMIT = 3
  #WORD_REGEX_NOT = /[^\w@#$]/
  WORD_REGEX_NOT = /[^\w@]/

  
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

  def assign_notifications
    #my_post_news = []
    my_post_followers = []
    #assign mentioned users to be notified for future events
    #notify mentioned users to this event (being mentioned)
    post_words.only_usernames.each do |word|
      user_mentioned = User.findu(word.word)
      if user_mentioned
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
        next if user_mentioned.id == user.id
        
        PUN.create! :user_id_from   => user.id,
                    :user_id        => user_mentioned.id,
                    :post_id        => id,
                    :reason_trigger => Post::REASON_CREATED,  # someone created a post
                    :reason_why     => Post::REASON_MENTIONED # I relate to it because I was mentioned at it
      end
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
    filenames = post_files.map(&:filename).join(' ')
    
    words = text.split(' ')+filenames.split(/[\s.]/)
    words.uniq!
=begin
    if MyF.pg?
      inserts = []
      words.each { |word| inserts.push(Post.send(:sanitize_sql_array, ["(?, ?)", self.id, word])) if word.length >= 3 }
      sql = "INSERT INTO \"post_words\" (\"post_id\", \"word\") VALUES #{inserts.join(', ')}"
      #transaction {  }
      connection.execute(sql)
      #INSERT INTO "post_words" ("post_id", "word") VALUES (3, 'aaaaaaaaaaaaaaa')
    else
=end
      words.each { |word| post_words.create!(:word=>word) if word.length >= 3 }
    #end
    update_attribute :generated_words, true
    true
  end




  
  
  #SEARCH METHODS
  class << self
  
    def from_relation(user, source, options={})
      user = User.find(user) unless user.is_a? User
      
      source = user.followers_users   if source == :followers
      source = user.followings_users  if source == :followings
      source = user.friends_users     if source == :friends
      user_ids = source.collect(&:id)
      user_ids << user.id
      
                  #.where("is_comment = ? OR is_repost = ?", false, true)
      posts = Post.where(:user_id=>user_ids)
                  .where("on_timeline = ?", true)
                  .before(options[:before])
                  .as_a_result
                  
      posts = posts.where(:files_categories=>options[:filter]) if options[:filter]
      posts
    end

    def from_profile(user, options={})
      user = User.find(user) unless user.is_a? User
                        #.where("is_comment = ? OR is_repost = ?", false, true)
      posts = user.posts.where("on_timeline = ?", true)
                        .before(options[:before])
                        .as_a_result
      posts = posts.where(:files_categories=>options[:filter]) if options[:filter]
      posts
    end
    
    def from_search(text, options={})
      #TODO: options[:post_type]
      #TODO: options[:post_type_detail] jpg|gif|pdf|doc|ppt simplify table, string column instead of booleans, booleans are good for multiple file cases
      return nil unless text
      words = text.downcase.split(' ')
      
      post_ids = PostWord.select('DISTINCT post_id')
                         .where(:word=>words)
                         .limit(DEFAULT_LIMIT)
                         .collect(&:post_id)

      posts = Post.where(:id=>post_ids)
                  .before(options[:before])
                  .as_a_result
    end

    def mentions_count(username_at)
      PostWord.select('DISTINCT post_id')
               .where(:word=>username_at.downcase)
               .count
    end
  end
end
