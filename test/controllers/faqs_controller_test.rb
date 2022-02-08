require "test_helper"

class FaqsControllerTest < ActionDispatch::IntegrationTest

  setup do
    @faq = faqs(:faq1)
    @user = users(:user)
    @editor = users(:editor)
    @admin = users(:admin)
  end

  test "should get index if admin or editor" do
    [@admin, @editor].each do |user|
      sign_in(user)
      ability = Ability.new(user)
      assert ability.can? :index, Faq

      get :index
      assert_response :success

      sign_out user
    end
  end

  test "should not get index for other users" do
    sign_in @user
    ability = Ability.new(@user)
    assert ability.cannot? :index, Faq

    assert_raise CanCan::AccessDenied do
      get :index
    end

    sign_out @user
  end

  test "should get new if admin or editor" do
    [@admin, @editor].each do |user|
      sign_in user
      ability = Ability.new(user)
      assert ability.can? :new, Faq

      get new_faq_url
      assert_response :success

      sign_out user
    end
  end

  test "should not get new for other users" do
    sign_in @user
    ability = Ability.new(@user)
    assert ability.cannot? :new, Faq

    #assert_raise CanCan::AccessDenied do
    #  get new_faq_url
    #end

    sign_out @user
  end

  test "should get create if admin or editor" do
    [@admin, @editor].each do |user|
      sign_in user
      ability = Ability.new(user)
      assert ability.can? :create, Faq

      post faqs_url, params: { faq: { title: 'text' } }
      assert_response :success

      sign_out user
    end
  end

  test "should not get create for other users" do
    sign_in @user
    ability = Ability.new(@user)
    assert ability.cannot? :create, Faq

    assert_raise CanCan::AccessDenied do
      post faqs_url, params: { faq: { title: 'text' } }
    end

    sign_out @user
  end

  test "should get show if admin or editor" do
    [@admin, @editor].each do |user|
      sign_in user
      ability = Ability.new(user)
      assert ability.can? :show, Faq

      get faq_url(@faq)
      assert_response :success

      sign_out user
    end
  end

  test "should not get show for other users" do
    sign_in @user
    ability = Ability.new(@user)
    assert ability.cannot? :show, Faq

    assert_raise CanCan::AccessDenied do
      get faq_url(@faq)
    end

    sign_out @user
  end

  #test "should get edit" do
  #  get edit_faq_url(@faq)
  #  assert_response :success
  #end

  #test "should update faq" do
  #  patch faq_url(@faq), params: { faq: {  } }
  #  assert_redirected_to faq_url(@faq)
  #end

  #test "should destroy faq" do
  #  assert_difference("Faq.count", -1) do
  #    delete faq_url(@faq)
  #  end
  #
  #  assert_redirected_to faqs_url
  #end
end
