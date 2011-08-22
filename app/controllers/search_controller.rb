class SearchController < ApplicationController
  sub_layout 'double'

  before_filter do
    return redirect_to :root if !params[:text] || params[:text].length < 3
    @user = current_user
  end
  
  def posts
    #return render :nothing => true if !params[:text] || params[:text].length < 3
    @posts = Post.from_search(params[:text], get_post_options)
    render '/posts/index', :layout=>false
  end

  def paginated
    @posts = Post.from_search(params[:text], get_post_options)
  end

  def async
  end

end
