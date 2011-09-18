class PostsController < ApplicationController
  sub_layout 'triple'

  before_filter :must_login, :except => [:show, :generate_notifications]
#  caches_action  :generate_notifications, :expires_in => 1.minutes

  # POST /posts/create_post_status
  def create_status
    @post = current_user.posts.create!  :remote_ip  => request.remote_ip,
                                        :body       => params[:body],
                                        :files_categories => Post::CATEGORY_STATUS
    current_user.recount_posts
    render :nothing=>true
  end

  # POST /posts/create_post_image
  def create_image
    att = params[:image]
    category = att ? Post::CATEGORY_IMAGE : Post::CATEGORY_STATUS
    
    @post = current_user.posts.create!  :remote_ip  => request.remote_ip,
                                        :body       => params[:body],
                                        :files_categories => category
    current_user.recount_posts
    
    if att
      f = att.original_filename
      e = f.split('.').last
      c = category
      @post.post_files.create!(:image => params[:image], :category=>c, :extension=>e, :filename=>f)
      @post.save
    end
    render :nothing=>true
  end
  

  # POST /posts/create_comment
  def create_comment
    if @post = Post.find(params[:post][:post_id]) rescue nil
      @post ||= @post.post
      @comment = current_user.posts.create  :remote_ip  => request.remote_ip,
                                            :body       => params[:post][:body],
                                            :post_id    => @post.id,
                                            :files_categories => @post.files_categories,
                                            :files_extensions => @post.files_extensions
    end
    render :nothing=>true
  end

  # GET /posts/1
  def show
    post_id = params[:id].split('-').first
    redirect_to :root unless @post = Post.find(post_id)
    redirect_to @post.post if @post.post
    @user = @post.user
  end

  # GET /posts/1/ajax_comments
  def ajax_comments
    post = Post.find(params[:post_id])
    limit = params[:limit] || 50
    @comments = post.posts.size > 0 ? post.posts.order(:id) : []
    @users_hash = {}
    if @comments.size > 0
      users_id = @comments.map(&:user_id)
      users = User.select([:id, :username, :first_name, :last_name, :user_photo_id])
                  .where(:id=>users_id.uniq)
                  .limit(limit)
                  .includes(:user_photo)
      users.each { |u| @users_hash[u.id] = u }
    end
    render :layout => false
  end

  # GET /posts/ajax_posts_search
  def ajax_search
    string = params[:search].try(:downcase)
    options = {:before => params[:before]}
    @posts = Post.from_search(string, options)
    render('/posts/index', :layout=>false)
  end

  # POST /posts/1/like
  def like
    redirect_to :root unless @post = Post.find(params[:post_id])
    @post.like_it(current_user.id)
    render :nothing=>true
    #render :js=>"alert('servidor recebeu    thats the way!          Aham Aham...              I like it!')"
  end
  
  # GET /posts/1/likes
  def likes
    return redirect_to :root unless @post = Post.find(params[:post_id])
    @likes = @post.likes
    @user = @post.user
  end

  # DELETE /posts/1
  def destroy
    @post = Post.find(params[:id])
    @post.destroy if @post.user_id == cu_ro.id || @post.post.try(:user_id) == cu_ro.id
    render :nothing=>true
  end

  def generate_notifications
    #giving a little while to generate notifications helps because some of them will be deleted during this while
    Post.where(:generated_notifications=>false)
        .limit(30)
        .each &:assign_notifications
    Post.where(:generated_words=>false)
        .limit(30)
        .each &:create_words
    render :nothing => true
  end
end
