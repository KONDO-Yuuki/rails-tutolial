require 'test_helper'

class BookpostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @bookpost = bookposts(:orange)
  end

  test 'should redirect create when not logged in' do
    assert_no_difference 'Bookpost.count' do
      post bookposts_path, params: { bookpost: { content: 'Lorem ipsum' } }
    end
    assert_redirected_to login_url
  end

  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Bookpost.count' do
      delete bookpost_path(@bookpost)
    end
    assert_redirected_to login_url
  end
end
