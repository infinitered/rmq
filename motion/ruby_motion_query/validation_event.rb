module RubyMotionQuery
  class ValidationEvent
    def initialize(sender, event, block)
      @sender = sender
      @event = event
      @block = block
    end

    def fire!

      if @block
        case @block.arity
        when 2
          @block.call(@sender, self)
        when 1
          @block.call(@sender)
        else
          @block.call
        end
      end
    end

  end
end
