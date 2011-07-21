class PostsController < ApplicationController
  sub_layout 'double'

  before_filter :must_login, :except => [:show, :generate_notifications]
#  caches_action  :generate_notifications, :expires_in => 1.minutes
  
  # POST /posts/create_post
  def create_post
    @post = current_user.posts.create :remote_ip  => request.remote_ip,
                                      :body       => params[:body]
    
    #@post.save #|| puts(@post.errors)

    att = params[:image] || params[:audio] || params[:other]
    if att
      f = att.original_filename
      e = @post.files_extensions = f.split('.').last
      c = @post.files_categories = if params[:image]
        Post::CATEGORY_IMAGE
      elsif params[:audio]
        Post::CATEGORY_AUDIO
      elsif params[:other]
        Post::CATEGORY_OTHER
      else
        Post::CATEGORY_STATUS
      end
      
      @pfi = @post.post_files.create(:image => params[:image], :category=>c, :extension=>e, :filename=>f) if params[:image]
      @pfa = @post.post_files.create(:audio => params[:audio], :category=>c, :extension=>e, :filename=>f) if params[:audio]
      @pfo = @post.post_files.create(:other => params[:other], :category=>c, :extension=>e, :filename=>f) if params[:other]
      @post.save #|| puts(@post.errors)
    end
    @post.create_words
    current_user.recount_posts
=begin
    @post.has_image  = !!params[:image]
    @post.has_audio  = !!params[:audio]
    @post.has_other  = !!params[:other]
    @post.has_status = !(params[:image] || params[:audio] || params[:other])
=end
    #render :js=>"alert('sucesso: p: #{@post.id} pf: #{@pf.try(:id)}')"
    #render :js=>"alert('servidor erro: #{@post.errors.to_s} #{params[:post]}')" if @post.new_record?
    render :nothing=>true
  end

  # POST /posts/create_comment
  def create_comment
    parent = Post.find(params[:post][:post_id]) rescue nil
    return false unless parent
    
    @post = current_user.posts.create :remote_ip  => request.remote_ip,
                                      :body       => params[:post][:body],
                                      :post_id    => parent.id,
                                      :is_repost  => params[:post][:is_repost]=='1',
                                      :files_categories => parent.files_categories,
                                      :files_extensions => parent.files_extensions
    
    render :js=>"alert('servidor erro: #{@post.attributes.to_s}')" if @post.new_record?
  end

  # GET /posts/1
  def show
    redirect_to :root unless @post = Post.find(params[:id])
    @user = @post.user
    posts_fill_hashes( [@post] )
  end

  # GET /posts/1/ajax_comments
  def ajax_comments
    post = Post.find(params[:post_id])
    @comments = post.try(:posts) || []
    @users_hash = {}
    if @comments.size > 0
      @comments.reverse!
      users_id = @comments.map(&:user_id)
      users = User.select([:id, :username, :first_name, :last_name, :user_photo_id])
                  .where(:id=>users_id.uniq)
                  .includes(:user_photo)
      users.each { |u| @users_hash[u.id] = u }
    end
    render :layout => false
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
    @post.destroy
    render :nothing=>true
  end

  def generate_notifications
    #giving a little while to generate notifications helps because some of them will be deleted during this while
    Post.where(:generated_notifications=>false)
        .limit(10)
        .each &:assign_notifications
    #Like.where(:generated_notifications=>false)
    #    .limit(10)
    #    .each &:assign_notifications
    render :nothing => true
  end
end
