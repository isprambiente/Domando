require "test_helper"

class FaqTest < ActiveSupport::TestCase
  setup do
    @faq1 = faqs(:faq1)
    @faq2 = faqs(:faq2)
  end

  test 'valid from factory' do
    assert @faq1.valid?
    assert @faq2.valid?
  end

  ### Validations
  test 'title is required' do
    @faq1.title = ''
    assert_not @faq1.valid?
  end

  test 'title is unique' do
    @faq2.title = "Faq 1"
    assert_not @faq2.valid?
  end

  test 'structure is required' do
    @faq1.structure = ''
    assert_not @faq1.valid?
  end
end
