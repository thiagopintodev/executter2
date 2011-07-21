class SiteController < ApplicationController
  sub_layout 'double'

  def search
    redirect_to :root if !params[:text] || params[:text].length < 3
  end
  
  def posts
    return render :nothing => true if !params[:text] || params[:text].length < 3
    posts_fill_hashes( Post.from_search(params[:text], get_post_options)   )
    render '/posts/index', :layout=>false
  end

  def export_post
    
  end
  
end
