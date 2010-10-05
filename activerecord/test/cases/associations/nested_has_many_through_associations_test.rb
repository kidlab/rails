require "cases/helper"
require 'models/author'
require 'models/post'
require 'models/person'
require 'models/reference'
require 'models/job'
require 'models/reader'
require 'models/comment'
require 'models/tag'
require 'models/tagging'
require 'models/owner'
require 'models/pet'
require 'models/toy'
require 'models/contract'
require 'models/company'
require 'models/developer'
require 'models/subscriber'
require 'models/book'
require 'models/subscription'

class NestedHasManyThroughAssociationsTest < ActiveRecord::TestCase
  fixtures :authors, :books, :posts, :subscriptions, :subscribers, :tags, :taggings

  def test_has_many_through_a_has_many_through_association_on_source_reflection
    author = authors(:david)
    assert_equal [tags(:general), tags(:general)], author.tags
  end

  def test_has_many_through_a_has_many_through_association_on_through_reflection
    author = authors(:david)
    assert_equal [subscribers(:first), subscribers(:second), subscribers(:second)], author.subscribers
  end

  def test_distinct_has_many_through_a_has_many_through_association_on_source_reflection
    author = authors(:david)
    assert_equal [tags(:general)], author.distinct_tags
  end

  def test_distinct_has_many_through_a_has_many_through_association_on_through_reflection
    author = authors(:david)
    assert_equal [subscribers(:first), subscribers(:second)], author.distinct_subscribers
  end
  
  def test_nested_has_many_through_with_a_table_referenced_multiple_times
    author = authors(:bob)
    assert_equal [posts(:misc_by_bob), posts(:misc_by_mary)], author.similar_posts.sort_by(&:id)
  end
  
  def test_nested_has_many_through_as_a_join
    # All authors with subscribers where one of the subscribers' nick is 'alterself'
    authors = Author.joins(:subscribers).where('subscribers.nick' => 'alterself')
    assert_equal [authors(:david)], authors
  end
end
