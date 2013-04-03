class UserTheme < ActiveRecord::Base

  def self.paperclip_options(styles={})
    r = {}
    #r[:default_url] = "/images/default/:class_:attachment/:style.png"
    r[:default_url] = "/images/default/:class_:attachment/original.png"
    r[:styles] = styles
    path = "#{My.my_env}/:class_:attachment/:id_partition.:style.:extension"
    
    r[:path] = ":rails_root/public/system/#{path}"
    r[:url] = "/system/#{path}"
    r
  end

  has_attached_file :image, paperclip_options
  
  belongs_to :user#, :counter_cache=>true
  
  validates :user_id, :presence => true
  
  #validates_attachment_presence :image
	validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/gif', 'image/png', 'image/pjpeg', 'image/bmp']
	validates_attachment_size :image, :less_than => 1.megabytes #unless :image

end
