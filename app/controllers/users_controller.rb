class UsersController < ApplicationController
  sub_layout 'triple'
  
  before_filter :fill_user
  before_filter :must_login, :only => [:relate_panel, :relate]

  helper_method :user_me?,
                :profile_user

  def index
    @users = User.select([:id, :username, :first_name, :last_name, :user_photo_id]).limit(7).order('id DESC')
    render :layout=>false
  end

  def show
    return redirect_to :root unless @user
    unless current_user
      cookies[:interesting_user_ids] ||= ""
      cookies[:interesting_user_ids] += "#{@user.id},"
    end
    #@isme = @user.id == current_user_id
  end

  def ajax_relate_panel
    render :layout=>false
  end

  def ajax_relate
    current_user.relate(@user, params[:relation_type])
    current_user.recount_relations
    @user.recount_relations
    #render :js=>"alert('server saved your #{option} :)')"
  end
  

  def likes
    @likes = Like.all
    render "/likes/index", :layout=>false
  end


  #can't be cached
  def ajax_posts_mention
    @posts = Post.from_search(@user.u_, get_post_options)
    render('/posts/index', :layout=>false)
  end

  

  helper_method :user_cache_key
  
  before_filter :post_fill_hashes_from_profile,
                :only =>  [:ajax_posts_all,
                           :ajax_posts_status,
                           :ajax_posts_image,
                           :ajax_posts_audio,
                           :ajax_posts_other
                           ]
                                             
  def ajax_posts_all
  end

  def ajax_posts_status
  end

  def ajax_posts_image
  end

  def ajax_posts_audio
  end

  def ajax_posts_other
  end

  def ajax_relations_following
    @users = @user.followings_users.order('users.updated_at DESC').limit(25)
    render 'user', :layout=>false
  end
  def ajax_relations_follower
    @users = @user.followers_users.order('users.updated_at DESC').limit(25)
    render 'user', :layout=>false
  end
  def ajax_relations_friend
    @users = @user.friends_users.order('users.updated_at DESC').limit(25)
    render 'user', :layout=>false
  end

  def ajax_relations_sidebar_friend
    @users = @user.friends_users.order('users.updated_at DESC').limit(25)
    render 'user_sidebar', :layout=>false
  end

  caches_action :ajax_suggestions_sidebar, :expires_in=>5.minutes

  def ajax_suggestions_sidebar
    @users = User.order('id DESC').limit(15)
    render 'user_sidebar', :layout=>false
  end

  
  protected

  def post_fill_hashes_from_profile
    @posts = Post.from_profile(@user, get_post_options) #unless fragment_exist? user_cache_key
    render('posts', :layout=>false)
  end
  
  def user_cache_key
    [@user.cache_key, action_name].join('/')
  end

  def user_me?
    current_user.try(:id) == @user.try(:id)
  end
  
  def fill_user
    if params[:user_id]||params[:id]
      @user = current_user if (current_user && current_user.id == params[:user_id]||params[:id])
      @user ||= User.find(params[:user_id]||params[:id])
    elsif params[:username]
      @user = current_user if (current_user && current_user.username.downcase == params[:username].downcase)
      @user ||= User.findu(params[:username])
    elsif current_user
      @user = current_user
    end
  end

  def profile_user
    @profile_user ||= fill_user
  end
end
