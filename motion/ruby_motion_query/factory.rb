module RubyMotionQuery
  class RMQ
    # This is used internally, to get a new rmq instance, just call "rmq" in your view or controller or
    # just create a new one like so: RubyMotionQuery::RMQ.new
    #
    # @return [RMQ]
    def create_blank_rmq
      RMQ.create_with_array_and_selectors([], self.selectors, @context)
    end

    # This is used internally, to get a new rmq instance, just call "rmq" in your view or controller or
    # just create a new one like so: RubyMotionQuery::RMQ.new
    #
    # @return [RMQ]
    def create_rmq_in_context(*selectors)
      RMQ.create_with_selectors(selectors, @context)
    end

    class << self

      # This is used internally, to get a new rmq instance, just call "rmq" in your view or controller or
      # just create a new one like so: RubyMotionQuery::RMQ.new
      #
      # @return [RMQ]
      def create_with_selectors(selectors, context, parent_rmq = nil)
        q = RMQ.new
        q.context = context
        q.parent_rmq = parent_rmq
        q.selectors = selectors
        q
      end

      # This is used internally, to get a new rmq instance, just call "rmq" in your view or controller or
      # just create a new one like so: RubyMotionQuery::RMQ.new
      #
      # @return [RMQ]
      def create_with_array_and_selectors(array, selectors, context, parent_rmq = nil) # TODO, convert to opts
        q = RMQ.new
        q.context = context
        q.selectors = selectors
        q.parent_rmq = parent_rmq
        q.selected = array # Must be last
        q
      end

    end
  end

end
