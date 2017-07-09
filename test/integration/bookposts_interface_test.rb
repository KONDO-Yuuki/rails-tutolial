require 'test_helper'

class BookpostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
  end

  test 'bookpost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    # 無効な送信
    assert_no_difference 'Bookpost.count' do
      post bookposts_path, params: { bookpost: { content: ('a' * 141) } }
    end
    assert_select 'div.error_explanation'
    # 有効な送信
    content = 'This bookpost really ties the room together'
    assert_difference 'Bookpost.count', 1 do
      post bookposts_path, params: { bookpost: { content: content } }
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body
    # 投稿を削除する
    assert_select 'a', text: 'delete'
    first_bookpost = @user.bookposts.paginate(page: 1).first
    assert_difference 'Bookpost.count', -1 do
      delete bookpost_path(first_bookpost)
    end
    # 違うユーザーのプロフィールにアクセス (削除リンクがないことを確認)
    get user_path(users(:archer))
    assert_select 'a', text: 'delete', count: 0
  end
end
