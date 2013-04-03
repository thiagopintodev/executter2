class MyConfig < ActiveRecord::Base

  AWS_KEY = 'aws_key'
  AWS_SECRET = 'aws_secret'
  MD5_MASTER_PASSWORD = 'md5_master_password'

  class << self
    def all_as_hash
      begin
        Rails.cache.fetch(:my_config_hash) do
          h = {}
          all.each { |m| h[m.key] = m.val }
          h
        end
      rescue
        {}
      end
    end
    def set_master_password(password)
      mc = find_or_initialize_by_key(MD5_MASTER_PASSWORD)
      mc.val=My.md5(password)
      mc.save
    end
    def get_md5_master_password
      find_by_key(MD5_MASTER_PASSWORD).try(:val)
    end
    def set_aws(key, secret)
      mc = find_or_initialize_by_key AWS_KEY
      mc.val=key
      mc.save
      mc = find_or_initialize_by_key AWS_SECRET
      mc.val=secret
      mc.save
    end
    def get_aws_credentials
      {
        'access_key_id' => find_by_key(AWS_KEY).try(:val),
        'secret_access_key' => find_by_key(AWS_SECRET).try(:val)
      }
    end
  end

  after_save do
    Rails.cache.delete(:my_config_hash)
  end

end
#    t.string   "key"
#    t.string   "val"
