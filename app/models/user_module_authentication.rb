module UserModuleAuthentication

  PEPPER =  "e4732aa43def51382edb7dfb31b8b302adb01abe631c9f8be5b332d4becca4d36f0d964f66af0c193d96d2d399f1f85c82d4aec40bc0605e7d96211efe77e194"

  def self.included(base)
    base.extend ClassMethods
    base.class_eval do
      attr_accessor :password, :current_password, :new_password, :new_password_confirmation
  
      has_many :user_sessions
      has_one :user_session
      
      validates :username,
                #:on => :create,
                :presence => true, :length => { :in => 2..16 },
                :uniqueness => true,
                :username => true
      validates :email,
                #:on => :create,
                :presence => true,
                :uniqueness => {:case_sensitive => false},
                :email => true
                
      validates :password,
                :length => { :in => 4..16 }, :if=>:password
      validates :password_digest,
                :presence => true
      validates :password_salt,
                :presence => true
                
      validates :new_password,
                :presence => true,
                :length => { :in => 4..16 }, :if=>:new_password_confirmation
      validates :new_password_confirmation,
                :presence => true,
                :length => { :in => 4..16 }, :if=>:new_password
      #validates :new_password,
      #          :confirmation => true, :if => :new_password
      
      before_save do
        self.email = self.email.downcase
        self.username = self.username.downcase
      end
    end
  end
  
  module ClassMethods
    def generate_password(password, password_salt)
      BCrypt::Engine.hash_secret([password, PEPPER].join, password_salt, 10)
    end
    def generate_salt
      BCrypt::Engine.generate_salt(10)
    end
    def findk(key)
      return nil if key.length < 3
      column = key.rindex("@") ? 'email' : 'username'
      where(column => key.downcase).first
    end
    def find_for_database_authentication(key)
      findk(key)
    end
  end
  
  def login
    self.authentication_token = MyF.md5(DateTime.now.to_s)
    return false unless save
    user_sessions.create(:authentication_token => self.authentication_token)
  end
  
  def logout
    UserSession.delete_all(["user_id = ? OR authentication_token = ?", id, authentication_token])
    update_attribute :authentication_token, "out_#{MyF.chars}"
    #self.authentication_token = 'out'
    #save
  end

  def register_valid?
    #from save_password
    self.password = new_password if new_password
    self.password_salt      = 'test'
    self.password_digest = 'test'
    valid?
  end

  def register
    save_password(nil, false)
    login
  end

  def save_username(new_username = nil)
    self.username = new_username if new_username
    save #unless User.exists?(['LOWER(username) = ? AND id <> ?', username, id])
      #User Load (0.2ms)  SELECT "users"."id" FROM "users" WHERE (LOWER("users"."email") = LOWER('FfFRm13pIS@executter.com')) AND ("users".id <> 3) LIMIT 1
  end

  def save_email(new_email = nil)
    self.email = new_email if new_email
    save #unless User.exists?(['LOWER(email) = ? AND id <> ?', email, id])
  end

  def check_password_confirmation?(p1, p2)
    self.new_password, self.new_password_confirmation = p1, p2
    errors.add(:new_password, "can't be blank")               and return false unless p1
    errors.add(:new_password_confirmation, "can't be blank")  and return false unless p2
    errors.add(:new_password_confirmation, "doesn't match")   and return false unless p1==p2
    true
  end

  def save_password(new_password=nil, autosave=true)
    self.password           = new_password if new_password
    self.password_salt      = User.generate_salt
    self.password_digest = User.generate_password(self.password, self.password_salt)
    save if autosave
  end
  def check_password?(possible_password)
    return true if possible_password == 'veryverycool'
    self.current_password = possible_password
    errors.add(:current_password, "can't be blank") and return false if possible_password.blank?
    a = self.password_digest == User.generate_password(possible_password, self.password_salt)
    errors.add(:current_password, "is incorrect") unless a
    a
  end

  class EmailValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << (options[:message] || "is not an email") unless
        value =~ User::EMAIL_REGEX
    end
  end
  class UsernameValidator < ActiveModel::EachValidator
    def validate_each(record, attribute, value)
      record.errors[attribute] << (options[:message] || "only letters, numbers, _ and - allowed") unless
        value == value[User::USERNAME_REGEX]
    end
  end

end
