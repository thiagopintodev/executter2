class UserTheme < ActiveRecord::Base

  def self.paperclip_options(styles={})
    r = {}
    #r[:default_url] = "/images/default/:class_:attachment/:style.png"
    r[:default_url] = "/images/default/:class_:attachment/original.png"
    r[:styles] = styles
    path = "/#{My.my_env}/:class_:attachment/:id_partition.:style.:extension"
    
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

  has_attached_file :image, paperclip_options
=begin
  (  :original => ["700x2800>", :jpg],
                                                :thumb => ["250x250#", :jpg]
                                             )
=end                                           
  belongs_to :user#, :counter_cache=>true
  
  validates :user_id, :presence => true
  
  #validates_attachment_presence :image
	validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/gif', 'image/png', 'image/pjpeg', 'image/bmp']
	validates_attachment_size :image, :less_than => 1.megabytes #unless :image

end
