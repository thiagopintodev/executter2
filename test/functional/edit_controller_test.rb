require 'test_helper'

class EditControllerTest < ActionController::TestCase
  test "should get basic" do
    get :basic
    assert_response :success
  end

  test "should get basic_put" do
    get :basic_put
    assert_response :success
  end

  test "should get username" do
    get :username
    assert_response :success
  end

  test "should get username_put" do
    get :username_put
    assert_response :success
  end

end
