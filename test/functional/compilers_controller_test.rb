require 'test_helper'

class CompilersControllerTest < ActionController::TestCase
  setup do
    @compiler = compilers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:compilers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create compiler" do
    assert_difference('Compiler.count') do
      post :create, compiler: { description: @compiler.description, image_id: @compiler.image_id, language_id: @compiler.language_id, name: @compiler.name, run_config: @compiler.run_config }
    end

    assert_redirected_to compiler_path(assigns(:compiler))
  end

  test "should show compiler" do
    get :show, id: @compiler
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @compiler
    assert_response :success
  end

  test "should update compiler" do
    put :update, id: @compiler, compiler: { description: @compiler.description, image_id: @compiler.image_id, language_id: @compiler.language_id, name: @compiler.name, run_config: @compiler.run_config }
    assert_redirected_to compiler_path(assigns(:compiler))
  end

  test "should destroy compiler" do
    assert_difference('Compiler.count', -1) do
      delete :destroy, id: @compiler
    end

    assert_redirected_to compilers_path
  end
end
