require "test_helper"

class UserFaqTest < ActiveSupport::TestCase
  test 'valid from factory' do
    user = User.new(username: 'User 1', structure: 'Test1')
    faq = Faq.new(title: 'Faq 1', content: 'Test', structure: 'Test1', visibility: 0, tag_list: ['computer'])
    user_faq = UserFaq.new(user: user, faq: faq)
    assert user_faq.valid?
  end

  ### Validations
  test 'user is required' do
    faq = Faq.new(title: 'Faq 1', content: 'Test', structure: 'Test1', visibility: 0, tag_list: ['computer'])
    user_faq = UserFaq.new(faq: faq)
    assert_not user_faq.valid?
  end

  test 'faq is required' do
    user = User.new(username: 'User 1', structure: 'Test1')
    user_faq = UserFaq.new(user: user)
    assert_not user_faq.valid?
  end
end
