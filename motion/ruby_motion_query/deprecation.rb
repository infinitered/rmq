module RubyMotionQuery
  class Deprecation
    def self.warn(method_called, message = nil)
      puts "[RMQ Warning] The `#{method_called}` method has been deprecated and will be removed in a future version of RMQ. #{message}" if rmq.device.simulator?
    end
  end
end
