module RubyMotionQuery
  class RMQ
    def self.debug
      Debug
    end

    def self.debugging?
      @debugging ||= ENV['rmq_debug'] == 'true'
    end

    def self.debugging=(flag)
      @debugging = flag
    end

    # @return [Debug]
    def debug 
      Debug
    end
  end

  # Notes:
  #
  # rake debug=1 NSZombieEnabled=YES
  #
  # rake debug=1 NSZombieEnabled=YES MallocStackLogging=1
  # /usr/bin/malloc_history 89032 0x9508da0
  # /usr/bin/malloc_history 47706 0x937e5c0 | grep "rb_scope__.+?__"
  class Debug
    class << self
      # Warning, this is very slow
      def log_detailed(label, params = {})
        return unless RMQ.app.development? || RMQ.app.test?

        objects = params[:objects]
        skip_first_caller = params[:skip_first_caller]

        if block_given? && !objects
          objects = yield
        end

        callers = caller
        callers = callers.drop(1) if skip_first_caller

        out = %(

          ------------------------------------------------
          Deep log - #{label}
          At: #{Time.now.to_s}

          Callers: 
          #{callers.join("\n - ")}

          Objects:
          #{objects.map{|k, v| "#{k.to_s}: #{v.inspect}" }.join("\n\n")}
          ------------------------------------------------

        ).gsub(/^ +/, '')

        NSLog out
        label
      end

      # Warning, this is very slow to output log, checking truthy however is 
      # basically as performant as an if statement
      #
      # @example
      #
      # # foo and bar are objects we want to inspect
      # rmq.debug.assert(1==2, 'Bad stuff happened', {
      #   foo: foo,
      #   bar: bar
      # })
      def assert(truthy, label = nil, objects = nil)
        if (RMQ.app.development? || RMQ.app.test?) && !truthy
          label ||= 'Assert failed'
          if block_given? && !objects
            objects = yield
          end
          log_detailed label, objects: objects, skip_first_caller: true
        end
      end
    end
  end
end


#class UIViewController
  #def dealloc
    #puts "dealloc controller #{self.object_id}"
    #super
  #end
#end
