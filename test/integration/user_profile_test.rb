require 'test_helper'

class UserProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper

  def setup
    @user = users(:michael)
  end

  test 'profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.bookposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.bookposts.paginate(page: 1).each do |bookpost|
      assert_match bookpost.content, response.body
    end
  end
end
