class MobileController < ApplicationController

  before_filter :must_login, :except=>[:login, :post_login]
  
  def login
  end

  def post_login
    render :login
  end

  def index
  end

  def index_posts_new
  end

  def index_posts
  end

  def index_mentions
  end

  def user
  end

  def user_posts
  end

  def post
  end

  def post_posts
  end

  def post_posts_new
  end

  def city
  end

  def city_posts
  end

end
