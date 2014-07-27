module RubyMotionQuery
  class ValidationEvent
    def initialize(block)
      @block = block
    end

    def fire!
      @block.call if @block
    end
  end
end
