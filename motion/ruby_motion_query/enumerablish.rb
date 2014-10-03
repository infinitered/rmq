module RubyMotionQuery
  class RMQ
    # I'm purposly not including Enumerable,
    # please use to_a if you want one


    # @return [RMQ]
    def <<(value)
      selected << value if value.is_a?(UIView)
      self
    end

    # @return [RMQ]
    #
    # @example
    #   rmq(UILabel)[3]
    #   or
    #   rmq(UILabel)[1..5]
    def [](i)
      RMQ.create_with_array_and_selectors([selected[i]], @selectors, @context)
    end
    alias :eq :[]

    # @return [RMQ]
    def each(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.each(&block), @selectors, @context)
    end

    # @return [RMQ]
    def map(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.map(&block), @selectors, @context)
    end
    alias :collect :map

    # @return [RMQ]
    def select(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.select(&block), @selectors, @context)
    end

    # @return [RMQ]
    def detect(&block) # Unlike enumerable, detect and find are not the same. See find in transverse
      return self unless block
      RMQ.create_with_array_and_selectors(selected.select(&block), @selectors, @context)
    end

    # @return [RMQ]
    def grep(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.grep(&block), @selectors, @context)
    end

    # @return [RMQ]
    def reject(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.reject(&block), @selectors, @context)
    end

    # @return [RMQ]
    def inject(o, &block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.inject(o, &block), @selectors, @context)
    end
    alias :reduce :inject

    # @return [RMQ]
    def first
      # TODO, check if it fails with nil
      RMQ.create_with_array_and_selectors([selected.first], @selectors, @context)
    end
    # @return [RMQ]
    def last
      # TODO, check if it fails with nil
      RMQ.create_with_array_and_selectors([selected.last], @selectors, @context)
    end

    # @return [Array]
    def to_a
      selected
    end

    # @return [Integer] number of views selected
    def length
      selected.length
    end
    alias :size :length
    alias :count :length
  end
end
