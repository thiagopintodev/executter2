require 'test_helper'

class SearchControllerTest < ActionController::TestCase
  test "should get paginated" do
    get :paginated
    assert_response :success
  end

  test "should get async_holder" do
    get :async_holder
    assert_response :success
  end

  test "should get asyn_ajax" do
    get :asyn_ajax
    assert_response :success
  end

end
