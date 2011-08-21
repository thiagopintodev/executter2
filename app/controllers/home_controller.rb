class HomeController < ApplicationController
  sub_layout 'double'

  before_filter :must_login
  #authentication_token as a cache key for home controller

  before_filter do
    @user = cu_ro
  end

  def mobile_index
    @posts = Post.from_relation(current_user, :followings, get_post_options)
  end


  def invite
    params[:emails].downcase.gsub(/,|;/,' ').split(' ').each do |email|
      if u = User.finde(email)
        current_user.relate(u, :follow)
      else
        current_user.invites.create(:email_to => email)
      end
    end
    current_user.recount_relations
    redirect_to :root
  end


  def index
  end


  def forms
    render :layout=>false
  end

  def ajax_notifications
    check_user_session
    pun_list = cu_ro.post_user_news.order("id DESC")
    @pun_list_unread_count = pun_list.where(:is_read => false).count
    @pun_list = pun_list.limit(6)
    render :layout=>false
  end

  def mark_notifications_as_read
    PUN.update_all ["is_read = ?", true], ["user_id = ?", current_user.id]
    render :nothing=>true
  end

  # partial html via ajax

  def posts_followings_all
   @posts = Post.from_relation(current_user, :followings, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_followings_status
    @posts = Post.from_relation(current_user, :followings, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_followings_image
    @posts = Post.from_relation(current_user, :followings, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_followings_audio
    @posts = Post.from_relation(current_user, :followings, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_followings_other
    @posts = Post.from_relation(current_user, :followings, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_followers
    @posts = Post.from_relation(current_user, :followers, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_mention
    @posts = Post.from_search(current_user.u_, get_post_options)
    render '/posts/index', :layout=>false
  end
end
