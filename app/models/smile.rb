class Smile < ActiveRecord::Base

  def self.all_as_hash
    Rails.cache.fetch(:smiles) do
      h = {}
      where(:is_visible=>true).each { |m| h[m.key] = m.image.url }
      h
    end
  end
  
  def self.paperclip_options(styles={})
    r = {}
    r[:default_url] = "/images/default/:class_:attachment/:style.png"
    r[:styles] = styles
    path = "/#{MyF.my_env}/:class_:attachment/:id.:extension"
    
    if MyF.s3_credentials
      r[:storage] = :s3
      r[:s3_credentials] = MyF.s3_credentials
      r[:bucket] = "executter.com"
      r[:path] = path
    else
      r[:path] = ":rails_root/public/assets#{path}"
      r[:url] = "/assets#{path}"
    end
    r
  end

  after_save do
    Rails.cache.delete(:smiles)
  end

  validates :key, :presence=>true, :uniqueness=>true
  
  has_attached_file :image, paperclip_options

  
end
