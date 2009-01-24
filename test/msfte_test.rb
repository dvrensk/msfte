require File.join(File.dirname(__FILE__),'test_helper')

class MsfteTest < Test::Unit::TestCase

  # Fixtures are loaded by the test:setup task

  def test_fixtures
    hello_world = MsftePost.find 1
    assert_equal "A look at operating systems", hello_world.title
  end

  def test_raw_search
    posts = MsftePost.find_by_sql "SELECT * FROM msfte_posts WHERE CONTAINS(*, 'systems')"
    assert_equal(1, posts.size)
    assert_equal("A look at operating systems", posts.first.title)

    posts = MsftePost.find_by_sql "SELECT * FROM msfte_posts WHERE CONTAINS(*, '\"opera*\"')"
    assert_equal(1, posts.size)
    assert_equal("A look at operating systems", posts.first.title)
  end
end
