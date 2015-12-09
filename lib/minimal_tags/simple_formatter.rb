module MinimalTags
  # A very simple tag formatter using ActiveSupport's parameterize.
  # You should create your own rather than using this.
  class SimpleFormatter
    ##
    # Returns an array of normalized tags
    #
    # @param [Array] tags Tags to normalize
    #
    # @return [Array] Unique, parameterized tags
    def normalize(tags)
      tags.map(&:parameterize).uniq
    end
  end
end
