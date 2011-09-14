require 'test_helper'

class SmilesControllerTest < ActionController::TestCase
  setup do
    @smile = smiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:smiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create smile" do
    assert_difference('Smile.count') do
      post :create, :smile => @smile.attributes
    end

    assert_redirected_to smile_path(assigns(:smile))
  end

  test "should show smile" do
    get :show, :id => @smile.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @smile.to_param
    assert_response :success
  end

  test "should update smile" do
    put :update, :id => @smile.to_param, :smile => @smile.attributes
    assert_redirected_to smile_path(assigns(:smile))
  end

  test "should destroy smile" do
    assert_difference('Smile.count', -1) do
      delete :destroy, :id => @smile.to_param
    end

    assert_redirected_to smiles_path
  end
end
