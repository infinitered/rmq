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
    #   or
    #   rmq(UILabel)[2,3]
    def [](*args)
      RMQ.create_with_array_and_selectors(selected: Array(selected[*args]), selectors: @selectors, context: @context)
    end
    alias :eq :[]

    # @return [RMQ]
    def each(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected: selected.each(&block), selectors: @selectors, context: @context)
    end

    # @return [RMQ]
    def map(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected: selected.map(&block), selectors: @selectors, context: @context)
    end
    alias :collect :map

    # @return [RMQ]
    def select(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected: selected.select(&block), selectors: @selectors, context: @context)
    end

    # @return [RMQ]
    def detect(&block) # Unlike enumerable, detect and find are not the same. See find in transverse
      return self unless block
      RMQ.create_with_array_and_selectors(selected: selected.select(&block), selectors: @selectors, context: @context)
    end

    # @return [RMQ]
    def grep(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected: selected.grep(&block), selectors: @selectors, context: @context)
    end

    # @return [RMQ]
    def reject(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected: selected.reject(&block), selectors: @selectors, context: @context)
    end

    # @return [RMQ]
    def inject(o, &block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected: selected.inject(o, &block), selectors: @selectors, context: @context)
    end
    alias :reduce :inject

    # @return [RMQ]
    def first
      # TODO, check if it fails with nil
      RMQ.create_with_array_and_selectors(selected: [selected.first], selectors: @selectors, context: @context)
    end
    # @return [RMQ]
    def last
      # TODO, check if it fails with nil
      RMQ.create_with_array_and_selectors(selected: [selected.last], selectors: @selectors, context: @context)
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
