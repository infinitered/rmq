module RubyMotionQuery
  class RMQ
    # TODO question, should there be a rmq pool to reuse?

    # @return [RMQ]
    def create_blank_rmq
      RMQ.create_with_array_and_selectors([], self.selectors, @context)
    end

    # @return [RMQ]
    def create_rmq_in_context(*selectors)
      RMQ.create_with_selectors(selectors, @context)
    end

    class << self

      # @return [RMQ]
      def create_with_selectors(selectors, context)
        RMQ.new.tap do |o|
          o.context = context
          o.selectors = selectors
        end
      end

      # @return [RMQ]
      def create_with_array_and_selectors(array, selectors, context)
        RMQ.new.tap do |o|
          o.context = context
          o.selectors = selectors
          o.selected = array # Must be last
        end
      end

    end
  end
end
