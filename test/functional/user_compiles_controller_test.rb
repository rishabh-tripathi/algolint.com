require 'test_helper'

class UserCompilesControllerTest < ActionController::TestCase
  setup do
    @user_compile = user_compiles(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:user_compiles)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create user_compile" do
    assert_difference('UserCompile.count') do
      post :create, user_compile: { compiler_id: @user_compile.compiler_id, content_id: @user_compile.content_id, dependency: @user_compile.dependency, language_id: @user_compile.language_id, status: @user_compile.status, user_id: @user_compile.user_id }
    end

    assert_redirected_to user_compile_path(assigns(:user_compile))
  end

  test "should show user_compile" do
    get :show, id: @user_compile
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @user_compile
    assert_response :success
  end

  test "should update user_compile" do
    put :update, id: @user_compile, user_compile: { compiler_id: @user_compile.compiler_id, content_id: @user_compile.content_id, dependency: @user_compile.dependency, language_id: @user_compile.language_id, status: @user_compile.status, user_id: @user_compile.user_id }
    assert_redirected_to user_compile_path(assigns(:user_compile))
  end

  test "should destroy user_compile" do
    assert_difference('UserCompile.count', -1) do
      delete :destroy, id: @user_compile
    end

    assert_redirected_to user_compiles_path
  end
end
