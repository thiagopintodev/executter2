require 'test_helper'

class SiteControllerTest < ActionController::TestCase
  test "should get search" do
    get :search
    assert_response :success
  end

  test "should get locale" do
    get :locale
    assert_response :success
  end

end
