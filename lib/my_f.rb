class MyF
  class << self
    
    def my_env
      #heroku config:add MY_CUSTOM_ENV=staging --app 
      ENV['MY_CUSTOM_ENV'] || "my_custom_env_name"
    end
    alias :env :my_env
    
    def production?
      my_env == 'production'
    end
    
    def adapter_name
      Rails.configuration.database_configuration[Rails.env]["adapter"]
    end
    
    def pg?
      adapter_name == "postgresql"
    end
    
    def chars(size=10)
      s = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      Array.new(size){||s[rand(s.size)]}.join
    end
    
    def md5(s)
      #Digest::SHA1.hexdigest s
      #Digest::SHA256.hexdigest s
      Digest::MD5.hexdigest s
    end
    
  end
end
