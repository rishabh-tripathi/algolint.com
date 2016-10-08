require 'test_helper'

class ImageConfigsControllerTest < ActionController::TestCase
  setup do
    @image_config = image_configs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:image_configs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create image_config" do
    assert_difference('ImageConfig.count') do
      post :create, image_config: { access_config: @image_config.access_config, default_port: @image_config.default_port, dockerfile: @image_config.dockerfile, image_id: @image_config.image_id, image_type: @image_config.image_type, startup_config: @image_config.startup_config }
    end

    assert_redirected_to image_config_path(assigns(:image_config))
  end

  test "should show image_config" do
    get :show, id: @image_config
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @image_config
    assert_response :success
  end

  test "should update image_config" do
    put :update, id: @image_config, image_config: { access_config: @image_config.access_config, default_port: @image_config.default_port, dockerfile: @image_config.dockerfile, image_id: @image_config.image_id, image_type: @image_config.image_type, startup_config: @image_config.startup_config }
    assert_redirected_to image_config_path(assigns(:image_config))
  end

  test "should destroy image_config" do
    assert_difference('ImageConfig.count', -1) do
      delete :destroy, id: @image_config
    end

    assert_redirected_to image_configs_path
  end
end
