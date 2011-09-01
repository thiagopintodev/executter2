require 'test_helper'

class MobileControllerTest < ActionController::TestCase
  test "should get login" do
    get :login
    assert_response :success
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get index_posts_new" do
    get :index_posts_new
    assert_response :success
  end

  test "should get index_posts" do
    get :index_posts
    assert_response :success
  end

  test "should get index_mentions" do
    get :index_mentions
    assert_response :success
  end

  test "should get user" do
    get :user
    assert_response :success
  end

  test "should get user_posts" do
    get :user_posts
    assert_response :success
  end

  test "should get post" do
    get :post
    assert_response :success
  end

  test "should get post_posts" do
    get :post_posts
    assert_response :success
  end

  test "should get post_posts_new" do
    get :post_posts_new
    assert_response :success
  end

  test "should get city" do
    get :city
    assert_response :success
  end

  test "should get city_posts" do
    get :city_posts
    assert_response :success
  end

end
