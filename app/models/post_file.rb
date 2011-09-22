class PostFile < ActiveRecord::Base

  belongs_to :post, :counter_cache=>true
  
  Paperclip.interpolates :normalized_filename_with_extension do |attachment, style|
    attachment.original_filename.gsub( /[^a-zA-Z0-9_\.]/, '_').downcase
  end

  def self.paperclip_options(styles={})
    r = {}
    r[:default_url] = "/images/default/:class_:attachment/:style.png"
    r[:styles] = styles
    path = "/#{My.my_env}/:class_:attachment/:id_partition/:normalized_filename_with_extension"
    
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
  #has_attached_file :audio, paperclip_options
  #has_attached_file :other, paperclip_options

  def cod
    count_of_downloads 
  end
end
