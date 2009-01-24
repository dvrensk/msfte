require File.join(File.dirname(__FILE__),'test_helper')

class PaginationTest < Test::Unit::TestCase
  
  def test_simple_pagination_page
    comments = MsfteComment.find_with_msfte "series", :per_page => 3
    assert_equal(3, comments.size)
    assert_equal(4, comments.total_entries)

    previous = comments
    comments = MsfteComment.find_with_msfte "series", :per_page => 3, :page => 2
    assert_equal(1, comments.size)
    assert_equal(4, comments.total_entries)
    assert ! previous.include?(comments.first)
  end
end
