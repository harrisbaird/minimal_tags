require 'test_helper'

describe MinimalTags do
  [MongoidModel, ActiveRecordModel].each do |model_class|
    describe model_class do
      before do
        @doc1 = model_class.create(tags: ['hello world', 'this is a test', 'hello-world'])
        @doc2 = model_class.create(tags: ['hello world', 'another test'])
        @doc3 = model_class.create(tags: ['something different'], upcase_tags: ['hello world'])
        @doc4 = model_class.create(tags: nil)
      end

      after { model_class.delete_all }

      it 'adds tag_field class method' do
        assert_respond_to model_class, :tag_field
      end

      it 'adds methods for each defined tag field' do
        assert_respond_to model_class, :all_tags
        assert_respond_to model_class, :any_tags
        assert_respond_to model_class, :all_upcase_tags
        assert_respond_to model_class, :any_upcase_tags
      end

      it 'runs default formatter on save' do
        assert_equal ['hello-world', 'this-is-a-test'], @doc1.tags
      end

      it 'runs user defined formatter on save' do
        assert_equal ['HELLO WORLD'], @doc3.upcase_tags
      end

      it 'handles nil values' do
        assert_equal [], @doc4.tags
      end

      it 'querying any_*' do
        assert_equal [@doc1, @doc2], model_class.any_tags(['hello world', 'another test']).entries
      end

      it 'querying all_*' do
        assert_equal [@doc2], model_class.all_tags(['hello world', 'another test']).entries
      end

      it 'querying without_any_*' do
        assert_equal [@doc3, @doc4], model_class.without_any_tags(['hello world', 'another test']).entries
      end

      it 'querying without_all_*' do
        assert_equal [@doc1, @doc3, @doc4], model_class.without_all_tags(['hello world', 'another test']).entries
      end

      it 'allows changing default_formatter' do
        MinimalTags.default_formatter = ReverseFormatter.new
        model_class.tag_field :reverse_tags
        doc = model_class.create(reverse_tags: ['hello world'])
        assert_equal ['dlrow olleh'], doc.reverse_tags
        MinimalTags.default_formatter = MinimalTags::SimpleFormatter.new
      end
    end
  end
end
