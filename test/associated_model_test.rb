require File.join(File.dirname(__FILE__),'test_helper')

class AssociatedModelTest < Test::Unit::TestCase
  def setup
    @os = MsftePost.find 1
  end
  
  def test_simple_scope
    unscoped = MsfteComment.find_with_msfte "title"
    assert_equal(3, unscoped.size)
    comments = @os.msfte_comments.find_with_msfte "title"
    assert_equal(2, comments.size)

    unscoped = MsfteComment.find_with_msfte "sorry"
    assert_equal(2, unscoped.size)
    comments = @os.msfte_comments.find_with_msfte "sorry"
    assert_equal(1, comments.size)
  end
  
  def test_eager_loading
    posts = MsftePost.find_with_msfte "operating"
    assert_posts([:os], posts)
    assert ! posts.first.msfte_comments.loaded?
    
    posts = MsftePost.find_with_msfte "operating", :include => :msfte_comments
    assert_posts([:os], posts)
    assert posts.first.msfte_comments.loaded?
  end
  
  def test_joint_search
    # 'operating' will be found in post
    posts = MsftePost.find_with_msfte "operating", :include_in_search => :msfte_comments
    assert_posts([:os], posts)

    # 'checked' will be found in comments
    posts = MsftePost.find_with_msfte "checked", :include_in_search => :msfte_comments
    assert_posts([:windows], posts)
  end

  def test_attribute_specific_search
    comments = @os.msfte_comments.find_with_msfte "series", :search_attributes => [:title]
    assert_equal(2, comments.size)
  end
  
  def test_joint_search_with_attributes
    # 'checked' will be found in 'text' in comments
    posts = MsftePost.find_with_msfte "checked", :include_in_search => :msfte_comments, :search_attributes => {:msfte_comments => :title}
    assert_equal(0, posts.size)
    posts = MsftePost.find_with_msfte "checked", :include_in_search => :msfte_comments, :search_attributes => {:msfte_comments => :text}
    assert_equal(1, posts.size)
  end
  
  def test_ignore_base_model
    # Prove my assumptions: there are comments with the word 'secure' and a post with the word 'secure',
    # but the comments are not connected to the post.
    comments = MsfteComment.find_with_msfte "secure"
    assert_posts([:os], comments.map { |e| e.msfte_post }.uniq)
    posts = MsftePost.find_with_msfte "secure", :include_in_search => :msfte_comments
    assert_posts([:bsd,:os], posts)
    posts = MsftePost.find_with_msfte "secure"
    assert_posts([:bsd], posts)
    
    # Thus, searching for 'secure' through associations but ignoring the parent
    # should only return one post.
    posts = MsftePost.find_with_msfte "secure", :include_in_search => [:msfte_comments], :ignore_self => true
    assert_posts([:os], posts)
  end
  
  def test_joint_search_multiple_children
    posts = MsftePost.find_with_msfte "secure", :include_in_search => [:msfte_comments, :msfte_pingbacks]
    assert_posts([:os,:bsd], posts)
  end

  def test_joint_search_multiple_children_and_pagination
    posts = MsftePost.find_with_msfte "secure", :include_in_search => [:msfte_comments, :msfte_pingbacks], :per_page => 2
    assert_posts([:os,:bsd], posts)
  end


end
