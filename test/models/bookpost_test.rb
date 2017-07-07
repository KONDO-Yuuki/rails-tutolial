require 'test_helper'

class BookpostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)
    @bookpost = @user.bookposts.build(content: 'BookView')
  end

  test 'should be valid' do
    assert @bookpost.valid?
  end

  test 'user id should be present' do
    @bookpost.user_id = nil
    assert_not @bookpost.valid?
  end

  test 'content should not be present' do
    @bookpost.content = '   '
    assert @bookpost.valid?
  end

  test 'content should be at most 140 characters' do
    @bookpost.content = 'a' * 140
    assert @bookpost.valid?
    @bookpost.content = 'a' * 141
    assert_not @bookpost.valid?
  end

  test 'order should be most recent first' do
    assert_equal bookposts(:most_recent), Bookpost.first
  end
end
