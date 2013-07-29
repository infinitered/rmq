module RubyMotionQuery 
  class RMQ
    # I'm purposly not including Enumerable, 
    # please use to_a if you want one

    def <<(value)
      selected << value if value.is_a?(UIView)
      self
    end

    # @example
    #   rmq(UILabel)[3]
    #   or
    #   rmq(UILabel)[1..5]
    def [](i)
      RMQ.create_with_array_and_selectors([selected[i]], @selectors, @context)
    end
    alias :eq :[]

    def each(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.each(&block), @selectors, @context)
    end

    def map(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.map(&block), @selectors, @context)
    end
    alias :collect :map

    def select(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.select(&block), @selectors, @context)
    end

    def detect(&block) # Unlike enumerable, detect and find are not the same. See find in transverse
      return self unless block
      RMQ.create_with_array_and_selectors(selected.select(&block), @selectors, @context)
    end

    def grep(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.grep(&block), @selectors, @context)
    end

    def reject(&block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.reject(&block), @selectors, @context)
    end

    def inject(o, &block)
      return self unless block
      RMQ.create_with_array_and_selectors(selected.inject(o, &block), @selectors, @context)
    end
    alias :reduce :inject

    def first
      RMQ.create_with_array_and_selectors([selected.first], @selectors, @context)
    end
    def last
      RMQ.create_with_array_and_selectors([selected.last], @selectors, @context)
    end

    def to_a
      selected
    end

    def length
      selected.length
    end
    alias :size :length
    alias :count :length
  end
end
