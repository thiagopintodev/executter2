require 'test_helper'

class RegistrationControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get new_by_profile" do
    get :new_by_profile
    assert_response :success
  end

  test "should get new_by_invitation" do
    get :new_by_invitation
    assert_response :success
  end

  test "should get new_post" do
    get :new_post
    assert_response :success
  end

  test "should get new_by_profile_post" do
    get :new_by_profile_post
    assert_response :success
  end

  test "should get new_by_invitation_post" do
    get :new_by_invitation_post
    assert_response :success
  end

  test "should get confirm_email" do
    get :confirm_email
    assert_response :success
  end

  test "should get new_password" do
    get :new_password
    assert_response :success
  end

  test "should get new_password_post" do
    get :new_password_post
    assert_response :success
  end

end
