module RubyMotionQuery
  class RMQ
    # This is used internally, to get a new rmq instance, just call "rmq" in your view or controller or
    # just create a new one like so: RubyMotionQuery::RMQ.new
    #
    # @return [RMQ]
    def create_blank_rmq
      RMQ.create_with_array_and_selectors(selected: [], selectors: self.selectors, context: @context)
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
      def create_with_array_and_selectors(opts)
        q = RMQ.new
        q.context = opts.fetch(:context)
        q.selectors = opts.fetch(:selectors)
        q.parent_rmq = opts.fetch(:parent_rmq, nil)
        q.selected = opts.fetch(:selected)

        q
      end
    end
  end
end
