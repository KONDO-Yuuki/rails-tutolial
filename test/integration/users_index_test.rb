require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  def setup
    @admin     = users(:michael)
    @non_admin = users(:archer)
    @non_activated = users(:lana)
  end

  test 'index as admin including pagination and delete links
   without non_activated' do
    unactivated_counter = 0
    log_in_as(@admin)
    get users_path
    assert_template 'users/index'
    assert_select 'div.pagination'
    first_page_of_users = User.paginate(page: 1)
    first_page_of_users.each do |user|
      unless user.activated # activatedが付いていないユーザを数える　いけてないので要注意
        unactivated_counter += 1
        next
      end
      assert_select 'a[href=?]', user_path(user), text: user.name
      unless user == @admin
        assert_select 'a[href=?]', user_path(user), text: 'delete'
      end
    end
    assert_difference 'User.count', -1 do
      delete user_path(@non_admin)
    end
    assert_equal 1, unactivated_counter
  end

  test 'index as non-admin' do
    log_in_as(@non_admin)
    get users_path
    assert_select 'a', text: 'delete', count: 0
  end
end
