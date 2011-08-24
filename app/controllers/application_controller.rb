class ApplicationController < ActionController::Base
  include SubLayouts
  protect_from_forgery

  helper_method :current_user,
                :current_user_read_only,
                :cu,
                :cu_ro,
                :mobile_device?
  
  before_filter do
    #no  www
    #return redirect_to("http://executter.com") if request.host.starts_with? "www"
    
    #Time.zone = cookies[:tz]
    
    #prepare_for_mobile
    #cookies[:mobile] = request.host.starts_with? "m"
    #return redirect_to "http://m.localhost:3000"    if mobile_device?   and !request.host.starts_with?  "m"
    #return redirect_to "http://www.localhost:3000"  if !mobile_device?  and request.host.starts_with?   "m"
    #request.format = :mobile if mobile_device?
    
    #cookies[:locale] = request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first unless cookies[:locale]
    
    unless cookies[:locale]
      begin
        request.env['HTTP_ACCEPT_LANGUAGE'].split(';').first.split(',').each do |loc|
          cookies[:locale] = loc.downcase and break if I18n.available_locales.include?(loc.downcase.to_sym)
        end
      rescue
      end
    end
    cookies[:locale] = params[:locale] if params[:locale]
    I18n.locale = cookies[:locale] if cookies[:locale]
  end

  private
  
  def current_user
    return @cu if @cu
    sus = session[:user_session]
    return nil unless sus && user = User.where(:id=>sus[:id]).first
    return  @cu = user if user.authentication_token == sus[:auth_token]
    nil
  end
  
  def current_user_read_only
    return @cu_ro if @cu_ro
    return @cu_ro = @cu if @cu
    #this one searches from cache
    sus = session[:user_session]
    return nil unless sus && user = User.kv_find(sus[:id])
    return  @cu_ro = user if user.authentication_token == sus[:auth_token]
    nil
  end
  
  alias :cu_ro :current_user_read_only
  alias :cu :current_user
  
  def must_login
    not_allowed unless cu_ro
  end
  
  def must_admin
    not_allowed unless current_user
  end

  def mobile_device?
    return false
    #return true if cookies[:mobile]
    #request.user_agent =~ /Mobile|webOS/
  end

  def check_user_session
    return unless cu_ro
    sus = session[:user_session]
    if sus[:next_check_at].try('past?')
      sus[:next_check_at] = 30.minutes.from_now
      cu_ro.user_session.touch
    end
  end
  
  def get_post_options
    o = {:before => params[:before], :filter=>params[:filter], :post_type=>params[:post_type]}
    o[:before] ||= cu_ro.last_read_post_id+1 if cu_ro #+1 so it includes current :)
    o
  end

  private

  def not_allowed
    request.xhr? ? render(:nothing=>true) : redirect_to(:new)
  end
=begin
  def my_admin_only
  #, :notice=>"ONLY ADMIN IN"
    redirect_to root_path and return false unless current_user && current_user.admin?
  end
  protected
  
  def fill_user
    if params[:id]
      @user = User.findi(params[:id])
    elsif params[:username]
      @user = User.findu(params[:username])
    elsif current_user?
      @user = current_user
    end
  end
=end
end
