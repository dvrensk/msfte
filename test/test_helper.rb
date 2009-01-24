RAILS_ENV = 'test'
require File.expand_path(File.join(File.dirname(__FILE__), '..','..','..','..','config','environment.rb'))
require 'test/unit'
require 'msfte'
require 'active_record/fixtures'

class Test::Unit::TestCase
  POST_NAMES = [nil, :os, :windows, :linux, :bsd]
  def assert_posts (expected, actual)
    actual = actual.map { |e| POST_NAMES[e.id] }
    extra   = actual - expected
    missing = expected - actual
    extra_error   = extra.empty? ? '' : " got unexpected\n<#{extra.inspect}>"
    missing_error = missing.empty? ? '' : "#{extra.empty? ? '' : ' and' } was missing\n<#{missing.inspect}>"
    assert(missing.empty? && extra.empty?, "<#{expected.inspect}> expected but#{extra_error}#{missing_error}")
  end

  def assert_posts_in_order (expected, actual)
    actual = actual.map { |e| POST_NAMES[e.id] }
    assert_equal(expected, actual)
  end

  def assert_post_before (expected, actual)
    actual = actual.map { |e| POST_NAMES[e.id] }.select { |e| expected.include?(e) }
    assert_equal(expected, actual)
  end
end

class MsfteTestHelper
  def create_models
    sql("create_posts")
    sql("create_comments")
    sql("create_pingbacks")
    Fixtures.create_fixtures(File.join(File.dirname(__FILE__),'fixtures'), %w(msfte_posts msfte_comments msfte_pingbacks))
  end
  
  protected
  
  def sql (name)
    IO.read(File.join(File.dirname(__FILE__), 'db', "#{name}.sql")).split(/^GO\s*?$/).each do |command|
      # ActiveRecord::Base.logger.info command
      conn.execute command
    end
  end
  
  def conn
    ActiveRecord::Base.connection
  end
end

# Play models

class MsftePost < ActiveRecord::Base
  has_many :msfte_comments, :order => "[msfte_comments].[id] DESC"
  has_many :msfte_pingbacks
  acts_as_msfte
end

class MsfteComment < ActiveRecord::Base
  belongs_to :msfte_post
  acts_as_msfte
end

class MsftePingback < ActiveRecord::Base
  belongs_to :msfte_post
  acts_as_msfte
end
