module MinimalTags
  # A very simple tag formatter.
  # You should create your own rather than using this.
  # The Stringex gem works well - https://github.com/rsl/stringex
  class SimpleFormatter
    ##
    # Returns an array of normalized tags
    #
    # @param [Array] tags Tags to normalize
    #
    # @return [Array] Unique, parameterized tags
    def normalize(tags)
      tags.map { |tag| tag.downcase.gsub(/\s/, '-') }.uniq
    end
  end
end
