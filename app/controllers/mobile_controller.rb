class MobileController < ApplicationController
  layout 'application_mobile'

  before_filter :must_login, :except=>[:login, :post_login]

  before_filter do
    @mobile = true
  end
  
  def login
    @user_session = UserSession.new
  end

  def post_login
    p = params[:user_session]
    @user = User.findk(p[:key])
    if @user and @user.check_password?(p[:password])
      @user.login
      session[:user_session] = {:id=>@user.id, :auth_token =>@user.authentication_token}
      UserAgent.note(request.user_agent)
      return redirect_to(:root)
    end
    @user_session = UserSession.new :key => p[:key]
    render :login
  end
=begin
  def index
  end

=end
  def index_posts
    @posts = Post.from_relation(current_user, :followings, {:before => params[:before]})
  end

  def index_mentions
    @posts = Post.from_search(cu_ro.u_, {:before => params[:before]})
  end


  
  def index_new_post
    @post = current_user.posts.create :remote_ip  => request.remote_ip,
                                      :origin     => Post::ORIGIN_MOBILE,
                                      :body       => params[:body]
    User.update(cu_ro.id, :last_read_post_id => @post.id) if @post
    redirect_to :action => :index_posts
  end

  def user
    if params[:user_id]||params[:id]
      @user = current_user if (current_user && current_user.id == params[:user_id]||params[:id])
      @user ||= User.find(params[:user_id]||params[:id])
    elsif params[:username]
      @user = current_user if (current_user && current_user.username.downcase == params[:username].downcase)
      @user ||= User.findu(params[:username])
    elsif current_user
      @user = current_user
    end
    
    @posts = Post.from_profile(@user, :before => params[:before])
  end

  def user_posts
  end

  def post
    @post = Post.find(params[:id])
    @comments = @post.posts.limit(50).order('id DESC').reverse
  end

  def post_comment_create
    if @post = Post.find(params[:post_id]) rescue nil
      @post ||= @post.post
      @comment = current_user.posts.create  :remote_ip  => request.remote_ip,
                                            :body       => params[:body],
                                            :post_id    => @post.id,
                                            :is_repost  => false,
                                            :origin     => Post::ORIGIN_MOBILE,
                                            :files_categories => @post.files_categories,
                                            :files_extensions => @post.files_extensions
      return redirect_to mobile_post_path(@post)
    end
    redirect_to :mobile_root
  end

  def post_posts_new
  end

  def city
  end

  def city_posts
  end

end
