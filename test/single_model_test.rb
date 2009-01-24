require File.join(File.dirname(__FILE__),'test_helper')

class SingleModelTest < Test::Unit::TestCase

  # Fixtures are loaded by the test:setup task

  def test_one_word
    posts = MsftePost.find_with_msfte "operating"
    assert_posts([:os], posts)

    posts = MsftePost.find_with_msfte "look"
    assert_posts([:os, :windows, :bsd], posts)
  end

  def test_one_prefix
    posts = MsftePost.find_with_msfte 'secu*'
    assert_posts([:bsd], posts)
    # Black box wild card
    posts = MsftePost.find_with_msfte :starts_with_any => 'secu'
    assert_posts([:bsd], posts)
  end

  def test_one_word_sorted
    posts = MsftePost.find_with_msfte 'windows'
    assert_post_before([:windows, :linux], posts)

    posts = MsftePost.find_with_msfte 'linux'
    assert_post_before([:linux, :windows], posts)
  end

  def test_one_prefix_sorted
    posts = MsftePost.find_with_msfte 'window*'
    assert_post_before([:windows, :linux], posts)

    posts = MsftePost.find_with_msfte 'linu*'
    assert_post_before([:linux, :windows], posts)
  end

  def test_word_or_word
    posts = MsftePost.find_with_msfte :matches_any => %w(nice secure)
    assert_posts([:linux, :bsd], posts)
  end

  def test_word_and_word
    posts = MsftePost.find_with_msfte :matches_all => %w(nice secure)
    assert_posts([:bsd], posts)
  end

  def test_prefix_or_prefix
    posts = MsftePost.find_with_msfte :starts_with_any => %w(hack secu)
    assert_posts([:linux, :bsd], posts)
    # alternative syntax
    posts = MsftePost.find_with_msfte :starts_with_any => %q(hack secu)
    assert_posts([:linux, :bsd], posts)
  end

  def test_prefix_and_prefix
    posts = MsftePost.find_with_msfte :starts_with_all => %w(hack secu)
    assert_posts([:bsd], posts)
    # alternative syntax
    posts = MsftePost.find_with_msfte :starts_with_all => %q(hack secu)
    assert_posts([:bsd], posts)
  end

  def test_one_phrase
    posts = MsftePost.find_with_msfte "operating systems"
    assert_posts([:os], posts)

    posts = MsftePost.find_with_msfte "nicer than"
    assert_posts([:os, :windows], posts)
  end

  def test_phrase_or_phrase
    posts = MsftePost.find_with_msfte :matches_any => ["phrase one", "phrase two"]
    assert_posts([:os, :windows, :linux], posts)
  end

  def test_phrase_and_phrase
    posts = MsftePost.find_with_msfte :matches_all => ["phrase one", "phrase two"]
    assert_posts([:windows], posts)
  end

  def test_anded_words_have_to_be_in_same_column
    posts = MsftePost.find_with_msfte :matches_all => ["systems", "series"]
    # would find :os if it considered both columns at the same time
    assert_posts([], posts)
  end
  
  def test_attribute_specific_search
    posts = MsftePost.find_with_msfte "linux", :search_attributes => [:title]
    assert_posts([:linux], posts)
    posts = MsftePost.find_with_msfte "linux", :search_attributes => :title
    assert_posts([:linux], posts)
    posts = MsftePost.find_with_msfte "linux", :search_attributes => [:title, :text]
    assert_posts([:linux, :os, :windows], posts)
  end
end
