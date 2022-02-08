require "application_system_test_case"

class FaqsTest < ApplicationSystemTestCase
  setup do
    @faq = faqs(:faq1)
    @admin = users(:admin)
  end

  test "visiting the index" do
    sign_in(@admin)
    visit faqs_url
    assert_selector "h2", text: I18n.t('index', scope: 'faq', default: 'List faqs')
    sign_out @admin
  end

  test "should create faq" do
    sign_in(@admin)
    visit faqs_url
    click_on I18n.t('new', scope: 'faq', default: 'New faq')
    click_on I18n.t('save')
    click_on I18n.t('cancel')
    sign_out @admin
  end
end
