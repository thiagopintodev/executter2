class RegistrationController < ApplicationController

  before_filter :must_login, :only => [:after_register]

  def new
    @user = User.new
    if Rails.env.development?
      @user.first_name = "Nome"
      chars = ("a".."z").to_a + ("A".."Z").to_a + ("0".."9").to_a
      sample_string = ""
      10.times { sample_string << chars[rand(chars.size-1)] }
      @user.email     = sample_string+"@executter.com"
      @user.username  = @user.password  = @user.last_name = sample_string
    end
  end

  def new_post
    @user = User.new(params[:user])
    
    if @user.register_valid?
      render :action=>:captcha
    else
      render :action =>:new
    end
  end

  def captcha
    #this action doesn't get hit at all
  end

  def captcha_post
    @user = User.new(params[:user])

    if MyF.production? and !verify_recaptcha(:model => @user, :message => 'Error at reCAPTCHA!')
      #because of reCAPTCHA
      return render :action =>:captcha
    end
    
    if @user.register
      session[:user_session] = {:id=>@user.id, :auth_token =>@user.authentication_token}
      #redirect_to :root
      UserAgent.note(request.user_agent)
      redirect_to :r_after_register
    else
      #because of @user.errors
      render :action =>:new
    end
  end

  #this paused redirection for this slow process will help with the overall flow
  def after_register
    Invite.where(:email_to=>current_user.email).each do |invite|
      Relation.relate_users(invite.user, current_user, :auto_friends)
      invite.destroy
    end
    (cookies[:interesting_user_ids] || '').split(',').each do |interesting_user_id|
      if u = User.findi(interesting_user_id)
        Relation.relate_users(current_user, u, :follow)
      end
    end
    current_user.recount_relations
    cookies[:interesting_user_ids] = "#{current_user.id},"#suggest next registration to follow me
    #render :nothing=>true
    redirect_to :root
  end

  def new_by_profile
  end

  def new_by_invitation
  end

  def new_by_profile_post
  end

  def new_by_invitation_post
  end

  def confirm_email
  end

  def new_password
  end

  def new_password_post
  end

end
