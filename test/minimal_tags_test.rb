require 'test_helper'

class UpcaseFormatter
  def normalize(tags)
    tags.map(&:upcase)
  end
end

class Document
  include Mongoid::Document
  include Mongoid::MinimalTags

  tag_field :tags
  tag_field :upcase_tags, formatter: UpcaseFormatter.new
end

describe Mongoid::MinimalTags do
  before do
    @doc1 = Document.create(tags: ['hello world', 'this is a test', 'hello-world'])
    @doc2 = Document.create(tags: ['hello world', 'another test'])
    @doc3 = Document.create(tags: ['something different'], upcase_tags: ['hello world'])
  end

  it 'adds tag_field class method' do
    assert_respond_to Document, :tag_field
  end

  it 'adds methods for each defined tag field' do
    assert_respond_to Document, :all_tags
    assert_respond_to Document, :any_tags
    assert_respond_to Document, :without_any_tags
    assert_respond_to Document, :all_upcase_tags
    assert_respond_to Document, :any_upcase_tags
    assert_respond_to Document, :without_any_upcase_tags
  end

  it 'runs default formatter on save' do
    assert_equal ['hello-world', 'this-is-a-test'], @doc1.tags
  end

  it 'runs user defined formatter on save' do
    assert_equal ['HELLO WORLD'], @doc3.upcase_tags
  end

  it 'querying any_*' do
    assert_equal [@doc1, @doc2], Document.any_tags(['hello world', 'another test']).entries
  end

  it 'querying all_*' do
    assert_equal [@doc2], Document.all_tags(['hello world', 'another test']).entries
  end

  it 'querying without_any_*' do
    assert_equal [@doc3], Document.without_any_tags(['hello world']).entries
  end
end
