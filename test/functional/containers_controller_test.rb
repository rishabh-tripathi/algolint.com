require 'test_helper'

class ContainersControllerTest < ActionController::TestCase
  setup do
    @container = containers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:containers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create container" do
    assert_difference('Container.count') do
      post :create, container: { assigned_to: @container.assigned_to, host: @container.host, image_id: @container.image_id, port: @container.port, stack_id: @container.stack_id, status: @container.status, type: @container.type }
    end

    assert_redirected_to container_path(assigns(:container))
  end

  test "should show container" do
    get :show, id: @container
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @container
    assert_response :success
  end

  test "should update container" do
    put :update, id: @container, container: { assigned_to: @container.assigned_to, host: @container.host, image_id: @container.image_id, port: @container.port, stack_id: @container.stack_id, status: @container.status, type: @container.type }
    assert_redirected_to container_path(assigns(:container))
  end

  test "should destroy container" do
    assert_difference('Container.count', -1) do
      delete :destroy, id: @container
    end

    assert_redirected_to containers_path
  end
end
