require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
  def setup
    @admin = users(:michael)
    @non_admin = users(:archer)
    @non_activated = users(:lana)
  end

  test 'show as activated and unactivated user' do
    log_in_as(@admin)
    get user_path(@admin)
    assert_template 'users/show'
    get user_path(@non_activated)
    assert_redirected_to root_path
  end
end
