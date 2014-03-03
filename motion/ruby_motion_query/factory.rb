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
    def create_rmq_in_context(*working_selectors)
      RMQ.create_with_selectors(working_selectors, @context)
    end

    class << self

      # This is used internally, to get a new rmq instance, just call "rmq" in your view or controller or
      # just create a new one like so: RubyMotionQuery::RMQ.new
      #
      # @return [RMQ]
      def create_with_selectors(working_selectors, current_context, working_parent_rmq = nil)
        q = RMQ.new
        q.context = current_context
        q.parent_rmq = working_parent_rmq
        q.selectors = working_selectors
        q
      end

      # This is used internally, to get a new rmq instance, just call "rmq" in your view or controller or
      # just create a new one like so: RubyMotionQuery::RMQ.new
      #
      # @return [RMQ]
      def create_with_array_and_selectors(array, working_selectors, current_context, working_parent_rmq = nil) # TODO, convert to opts
        q = RMQ.new
        q.context = current_context
        q.selectors = working_selectors
        q.parent_rmq = working_parent_rmq
        q.selected = array # Must be last
        q
      end

    end
  end

end
