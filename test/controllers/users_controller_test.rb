require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:user)
    @editor = users(:editor)
    @admin = users(:admin)
  end

  test "should get index" do
    sign_in(@admin)
    get users_url
    assert_response :success
    sign_out @admin
  end

  test "should get new" do
    sign_in(@admin)
    get new_user_url
    assert_response :success
    sign_out @admin
  end

  test "should create user" do
    sign_in(@admin)
    assert_difference("User.count") do
      post users_url, params: { user: { username: 'U1', structure: 'Test' } }
    end

    assert_redirected_to user_url(User.last)
    sign_out @admin
  end

  test "should show user" do
    sign_in(@admin)
    get user_url(@user)
    assert_response :success
    sign_out @admin
  end

  test "should get edit" do
    sign_in(@admin)
    get edit_user_url(@user)
    assert_response :success
    sign_out @admin
  end

  test "should update user" do
    sign_in(@admin)
    patch user_url(@user), params: { user: { username: 'U1' } }
    assert_response :success
    sign_out @admin
  end

  test "should destroy user" do
    sign_in(@admin)
    assert_difference("User.count", -1) do
      delete user_url(@user)
    end

    assert_response :success
    sign_out @admin
  end
end
