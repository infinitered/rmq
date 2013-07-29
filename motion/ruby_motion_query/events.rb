module RubyMotionQuery
  class RMQ
    def on(event, args = {}, &block)
      selected.each do |view|
        events(view).on(view, event, args, &block) 
      end

      self
    end

    def off(*events)
      selected.each do |view|
        events(view).off(events)
      end

      self
    end

    protected

    def events(view)
      view.rmq_data.events ||= Events.new
    end
  end

  class Events
    def initialize
      @event_set = {}
    end

    def has_events?
      !RMQ.is_blank?(@event_set)
    end

    def has_event?(event)
      @event_set.include?(event)
    end

    def on(view, event, args = {}, &block)
      raise "[RMQ Error]  Event already exists on this object: #{event}. Remove first, using .off" if @event_set[event]

      if rmqe = RubyMotionQuery::Event.new(view, event, block)
        rmqe.set_options(args)

        @event_set[event] = rmqe
      end

      view
    end

    def off(*events)
      events.flatten!
      events = @event_set.keys if events.length == 0

      events.each do |event| 
        if rm_event = @event_set.delete(event)
          rm_event.remove 
        end
      end

      self
    end

  end
end
