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
      def create_with_selectors(selectors, context, parent_rmq = nil)
        RMQ.new.tap do |o|
          o.context = context
          o.parent_rmq = parent_rmq
          o.selectors = selectors
        end
      end

      # @return [RMQ]
      def create_with_array_and_selectors(array, selectors, context, parent_rmq = nil) # TODO, convert to opts
        RMQ.new.tap do |o|
          o.context = context
          o.selectors = selectors
          o.parent_rmq = parent_rmq
          o.selected = array # Must be last
        end
      end

    end
  end
end
