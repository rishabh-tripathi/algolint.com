require 'test_helper'

class ContainerStacksControllerTest < ActionController::TestCase
  setup do
    @container_stack = container_stacks(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:container_stacks)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create container_stack" do
    assert_difference('ContainerStack.count') do
      post :create, container_stack: { compiler_id: @container_stack.compiler_id, count: @container_stack.count, created_by: @container_stack.created_by, dependency: @container_stack.dependency, image_id: @container_stack.image_id, image_type: @container_stack.image_type, language_id: @container_stack.language_id, name: @container_stack.name, status: @container_stack.status }
    end

    assert_redirected_to container_stack_path(assigns(:container_stack))
  end

  test "should show container_stack" do
    get :show, id: @container_stack
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @container_stack
    assert_response :success
  end

  test "should update container_stack" do
    put :update, id: @container_stack, container_stack: { compiler_id: @container_stack.compiler_id, count: @container_stack.count, created_by: @container_stack.created_by, dependency: @container_stack.dependency, image_id: @container_stack.image_id, image_type: @container_stack.image_type, language_id: @container_stack.language_id, name: @container_stack.name, status: @container_stack.status }
    assert_redirected_to container_stack_path(assigns(:container_stack))
  end

  test "should destroy container_stack" do
    assert_difference('ContainerStack.count', -1) do
      delete :destroy, id: @container_stack
    end

    assert_redirected_to container_stacks_path
  end
end
