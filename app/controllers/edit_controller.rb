class EditController < ApplicationController

  before_filter :must_login
  before_filter :fill_user
  sub_layout 'edit'
  
  def basic
  end

  def basic_put
    p = params[:user]#.slice('first_name', 'last_name')
    
    if @user.update_attributes(p)
      #redirect_to(:e_basic, :message => 'Like was successfully updated.')
      flash[:success] = 'Successfully updated.'
      redirect_to :e_basic
    else
      render :basic
    end
  end

  def cities
  end

  def cities_put
    p = params[:user][:living_city_base_id]
    if !p.empty?
      city = City.create_many_from_city_base(p)
      @user.living_city_id = city.id
    end
    p = params[:user][:born_city_base_id]
    if !p.empty?
      city = City.create_many_from_city_base(p)
      @user.born_city_id = city.id
    end
    if @user.save
      flash[:success] = 'Successfully updated.'
      redirect_to :back
    else
      render :cities
    end
  end
  
  def username
  end

  def username_put
    p = params[:user]
    if @user.check_password?(p['current_password']) && @user.save_username(p['username'])
      flash[:success] = 'Successfully updated.'
      redirect_to :back
    else
      render :username
    end
  end




  def email
  end

  def email_put
    p = params[:user]
    if @user.check_password?(p['current_password']) && @user.save_email(p['email'])
      flash[:success] = 'Successfully updated.'
      redirect_to :back
    else
      render :email
    end
  end




  def password
  end

  def password_put
    p = params[:user]
    if @user.check_password?(p['current_password']) && @user.check_password_confirmation?(p['new_password'], p['new_password_confirmation'])
      @user.save_password(p['new_password'])
      flash[:success] = 'Successfully updated.'
      redirect_to :back
    else
      render :password
    end
  end



  def photo
    
  end

  def photo_post
    up = current_user.user_photos.new :image => params[:image]
    if up.save
      current_user.update_attribute(:user_photo_id, up.id)
      #current_user.user_photo_id = up.id
      #current_user.save
      flash[:success] = 'Successfully uploaded.'
    else
      flash[:error] = up.errors.full_messages.first
    end
    render :photo
  end

  def theme
    #@user_theme = current_user.theme
    @user_theme = current_user.theme
  end

  def theme_post
    #ut = @user_theme.clone
    #
    @user_theme = current_user.theme
    ut = current_user.user_themes.build(params[:user_theme])
    if ut.valid?
      @user_theme.save if @user_theme.new_record?
      @user_theme.update_attributes(params[:user_theme])
      current_user.update_attribute(:user_theme_id, @user_theme.id)
      flash[:success] = 'Successfully updated.'
    else
      flash[:error] = ut.errors.full_messages.first
    end
=begin
    @user_theme = current_user.theme
    @user_theme.save if @user_theme.new_record?
    if @user_theme.update_attributes(params[:user_theme])
      current_user.update_attribute(:user_theme_id, @user_theme.id)
      flash[:message] = 'Successfully updated.'
    else
      flash[:message] = @user_theme.errors.full_messages.first
      #@user_theme = ut
    end
=end
    render :theme
  end


  private
  
  def fill_user
    @user = current_user
  end
end
