require 'test_helper'

class HomeControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end
=begin
  test "should post create_post" do
    post :create_post
    assert_response :success
  end
=end
  test "should get posts" do
    get :posts
    assert_response :success
  end

  test "should get posts_more" do
    get :posts_more
    assert_response :success
  end

end
