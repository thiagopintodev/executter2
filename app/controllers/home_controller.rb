class HomeController < ApplicationController
  sub_layout 'triple'

  before_filter :must_login
  #authentication_token as a cache key for home controller

  before_filter do
    @user = cu
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
    @pun_list_unread_count = cu.post_user_news.where(:is_read => false).count
    pun_list = cu.post_user_news.order("id DESC")
    #@pun_list = pun_list.limit(6)
    @pun_grouping = cu.post_user_news
                      .where(:is_read=>false)
                      .where('post_id IS NOT NULL')
                      .select('post_id, reason_why, reason_trigger, max(user_id_from) as user_id_from, max(created_at) as created_at, count(*)')
                      .group('post_id, reason_why, reason_trigger')
                      .limit(6)
    @users_from = User.where(:id=>@pun_grouping.map(&:user_id_from))
    render :layout=>false
  end

  def ajax_news_button
    return render :nothing => true unless cu.last_read_post_id
    @count = Post.from_relation_count_unread(cu, :followings)
    render :layout=>false
  end

  def mark_notifications_as_read
    PUN.update_all ["is_read = ?", true], ["user_id = ?", current_user.id]
    render :nothing=>true
  end

  # partial html via ajax

  def posts_followings_all_latest
    @posts = Post.from_relation(cu_ro, :followings, {:after=>cu_ro.last_read_post_id})
    @no_more = true
    User.update(cu_ro.id, :last_read_post_id => @posts.first.id) if @posts.first
    #expires_cache many
    render '/posts/index', :layout=>false
  end
  
  def posts_followings_all
    @posts = Post.from_relation(cu_ro, :followings, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_followings_status
    @posts = Post.from_relation(cu_ro, :followings, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_followings_image
    @posts = Post.from_relation(cu_ro, :followings, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_followings_audio
    @posts = Post.from_relation(cu_ro, :followings, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_followings_other
    @posts = Post.from_relation(cu_ro, :followings, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_followers
    @posts = Post.from_relation(cu_ro, :followers, get_post_options)
    render '/posts/index', :layout=>false
  end
  def posts_mention
    @posts = Post.from_search(cu_ro.u_, get_post_options)
    render '/posts/index', :layout=>false
  end
end
