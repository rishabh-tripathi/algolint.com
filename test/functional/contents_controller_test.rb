require 'test_helper'

class ContentsControllerTest < ActionController::TestCase
  setup do
    @content = contents(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:contents)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create content" do
    assert_difference('Content.count') do
      post :create, content: { compile: @content.compile, content: @content.content, desc: @content.desc, name: @content.name, sharability: @content.sharability, status: @content.status, type: @content.type, user_id: @content.user_id }
    end

    assert_redirected_to content_path(assigns(:content))
  end

  test "should show content" do
    get :show, id: @content
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @content
    assert_response :success
  end

  test "should update content" do
    put :update, id: @content, content: { compile: @content.compile, content: @content.content, desc: @content.desc, name: @content.name, sharability: @content.sharability, status: @content.status, type: @content.type, user_id: @content.user_id }
    assert_redirected_to content_path(assigns(:content))
  end

  test "should destroy content" do
    assert_difference('Content.count', -1) do
      delete :destroy, id: @content
    end

    assert_redirected_to contents_path
  end
end
