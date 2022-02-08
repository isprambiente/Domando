require "application_system_test_case"

class UsersTest < ApplicationSystemTestCase
  setup do
    @admin = users(:admin)
  end

  test "visiting the index" do
    sign_in(@admin)
    visit users_url
    assert_selector "h2", text: I18n.t('index', scope: 'user', default: 'List users')
    sign_out @admin
  end

  test "should create user" do
    sign_in(@admin)
    visit users_url
    click_on I18n.t('new', scope: 'user', default: 'New user')
    click_on I18n.t('cancel')
    sign_out @admin
  end

end
