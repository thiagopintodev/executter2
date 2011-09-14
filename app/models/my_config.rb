class MyConfig < ActiveRecord::Base

  #md5_master_password
  #aws_key
  #aws_secret

  class << self
    def all_as_hash
      Rails.cache.fetch(:my_config_hash) do
        h = {}
        all.each { |m| h[m.key] = m.val }
        h
      end
    end
    def set_aws(key, secret)
      mc = find_or_initalize_by_key 'aws_key'
      mc.val=key
      mc.save
      mc = find_or_initalize_by_key 'aws_secret'
      mc.val=secret
      mc.save
    end
    def set_master_password(password)
      mc = find_or_initalize_by_key('md5_master_password')
      mc.val=My.md5(password)
      mc.save
    end
    def get_md5_master_password
      find_by_key('md5_master_password').try(:val)
    end
    def get_aws_key
      find_by_key('aws_key').try(:val)
    end
    def get_aws_secret
      find_by_key('aws_secret').try(:val)
    end
  end

  after_save do
    Rails.cache.delete(:my_config_hash)
  end

end
#    t.string   "key"
#    t.string   "val"
