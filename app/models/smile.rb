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
    path = "#{My.my_env}/:class_:attachment/:id.:extension"
    
    r[:path] = ":rails_root/public/system/#{path}"
    r[:url] = "/system/#{path}"
    r
  end

  after_save do
    Rails.cache.delete(:smiles)
  end

  validates :key, :presence=>true, :uniqueness=>true
  
  has_attached_file :image, paperclip_options

  
end
