class SiteController < ApplicationController
  #sub_layout 'double'

  #caches_action :test, :expires_in => 30.minutes

  def notify_email
    
    
  end
  
  def test
    pun_grouping_post       = cu.post_user_news
                                .where('post_id IS NOT NULL')
                                .where(:is_read=>false, :is_mailed=>false)
                                .select('user_id, post_id, reason_why, reason_trigger, max(user_id_from) as user_id_from, max(created_at) as created_at, count(*)')
                                .group('user_id, post_id, reason_why, reason_trigger')
                                .order('created_at DESC')
                                .limit(6)
    @pun = pun_grouping_post.first
    I18n.locale = cu.locale
    render '/my_m/notification', :layout=>false
  end

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
