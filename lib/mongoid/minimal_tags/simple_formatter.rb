module Mongoid
  module MinimalTags
    class SimpleFormatter
      def normalize(tags)
        tags.map(&:parameterize).uniq
      end
    end
  end
end
