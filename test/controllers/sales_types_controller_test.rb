require 'test_helper'

class SalesTypesControllerTest < ActionController::TestCase
  setup do
    @sales_type = sales_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:sales_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create sales_type" do
    assert_difference('SalesType.count') do
      post :create, sales_type: { name: @sales_type.name }
    end

    assert_redirected_to sales_type_path(assigns(:sales_type))
  end

  test "should show sales_type" do
    get :show, id: @sales_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @sales_type
    assert_response :success
  end

  test "should update sales_type" do
    patch :update, id: @sales_type, sales_type: { name: @sales_type.name }
    assert_redirected_to sales_type_path(assigns(:sales_type))
  end

  test "should destroy sales_type" do
    assert_difference('SalesType.count', -1) do
      delete :destroy, id: @sales_type
    end

    assert_redirected_to sales_types_path
  end
end
