require "test_helper"

class UserTest < ActiveSupport::TestCase
  setup do
    @user = users(:user)
    @editor = users(:editor)
  end

  test 'valid from factory' do
    assert @user.valid?
  end

  ### Validations
  test 'username is required' do
    @user.username = ''
    assert_not @user.valid?
  end

  test 'username is unique' do
    @editor.username = "User 1"
    assert_not @editor.valid?
  end

  test 'structure is required' do
    @user.structure = ''
    assert_not @user.valid?
  end
end
