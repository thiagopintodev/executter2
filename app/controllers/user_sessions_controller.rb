class UserSessionsController < ApplicationController

=begin
  def after_login
    (cookies[:interesting_user_ids] || '').split(',').each do |interesting_user_id|
      Relation.relate_users(current_user, interesting_user_id, :suggggggggggggggest_follow)
    end
    current_user.recount_relations
    cookies[:interesting_user_ids] = nil
    render :nothing=>true
  end
=end

  #caches_action :send_password, :expires_in => 1.day
  def send_password
    key = Base64.urlsafe_decode64(params[:base64_key]) rescue ''
    @user = User.findk(key)
    return render :text=>"usuario nao encontrado" unless @user
    a,b = @user.email.split('@')
    @email_view = "#{a[0..2]}...@#{b}"
    @email_server = "http://#{b}"
    @new_password_token = MyF.md5(@user.authentication_token)
    MyM.forgot_password(@user, @new_password_token).deliver
  end

  def new_password
    @user = User.findu(params[:username])
    return render :text=>"usuario nao encontrado" unless @user
    return render :text=>"este link invalido ou expirou, gere-o novamente" unless params[:token] == MyF.md5(@user.authentication_token)
  end

  def create_password
    #@user = User.findu(params[:username])
    #return render :text=>"usuario nao encontrado" unless @user
    #return render :text=>"este link invalido ou expirou, gere-o novamente" unless params[:token] == MyF.md5(@user.authentication_token)
    new_password
    return render :new_password unless @user.save_password(params[:password])
    @user.login
    session[:user_session] = {:id=>@user.id, :auth_token =>@user.authentication_token}
    redirect_to(:root)
  end

  # GET /user_sessions
  # GET /user_sessions.xml
  def index
    @user_sessions = UserSession.order("updated_at DESC")
  end

  # GET /user_sessions/new
  # GET /user_sessions/new.xml
  def new
    @user_session = UserSession.new
  end

  # POST /user_sessions
  # POST /user_sessions.xml
  def create
    p = params[:user_session]
    @user = User.findk(p[:key])
    @user_session_found = !!@user
    if @user and @user.check_password?(p[:password])
      @user.login
      #session[:current_user_id] = @user.id
      session[:user_session] = {:id=>@user.id, :auth_token =>@user.authentication_token}
      UserAgent.note(request.user_agent)
      redirect_to(:root)
    else
      @user_session = UserSession.new :key => p[:key]
      render :action => "new"
    end
  end
  
  # PUT /user_sessions/1
  # PUT /user_sessions/1.xml
  def update
  
  end

  # DELETE /user_sessions/1
  # DELETE /user_sessions/1.xml
  def destroy
    if current_user
      #UserSession.delete_all(:authentication_token => session[:user_session][:authentication_token])
      current_user.logout
      session[:user_session] = nil
    end
    #session[:current_user_id] = nil
    redirect_to :new
  end
end
