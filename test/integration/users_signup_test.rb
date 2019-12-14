require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "invalid signu information" do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user: {name: "", email: "user@invalid", password: "foo", password_confirmation: "bar"}}
    end
    #check if a failed submission re-renders the 'new' action
    assert_template 'users/new'
  end

  test "valid signup information" do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name: "Example User",
                                          email: "user@example.com",
                                          password: "password",
                                          password_comfirmation: "password" }}
    end

    #follow the redirect method since that is what it behaves after a successful signup
    follow_redirect!
    #check if the template after a redirect is 'users/show'
    assert_template 'users/show'
  end
end
