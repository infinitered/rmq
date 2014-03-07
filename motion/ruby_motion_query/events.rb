module RubyMotionQuery
  class RMQ
    # Adds an event/gesture to all selected views
    #
    # @return [RMQ]
    #
    # on(event_or_gesture, options) do |sender, rmq_event|
    #   # your code when event fires
    # end
    #
    # Events for UIControl
    #  :touch
    #  :touch_up
    #  :touch_down
    #  :touch_start
    #  :touch_stop
    #  :change

    #  :touch_down_repeat
    #  :touch_drag_inside
    #  :touch_drag_outside
    #  :touch_drag_enter
    #  :touch_drag_exit
    #  :touch_up_inside
    #  :touch_up_outside
    #  :touch_cancel

    #  :value_changed

    #  :editing_did_begin
    #  :editing_changed
    #  :editing_did_change
    #  :editing_did_end
    #  :editing_did_endonexit

    #  :all_touch
    #  :all_editing

    #  :application
    #  :system
    #  :all

    # Gestures for UIView
    #  :tap
    #  :pinch
    #  :rotate
    #  :swipe
    #  :pan
    #  :long_press

    # Options for gestures
    #  :cancels_touches_in_view 
    #  :delegate 
    #  :taps_required 
    #  :fingers_required 
    #  :maximum_number_of_touches 
    #  :minimum_number_of_touches 
    #  :allowable_movement 
    #  :minimum_press_duration 
    #  :direction 
    #  :rotation 
    #  :scale 
    #
    # @example
    # rmq.append(UIButton).on(:touch) do |sender|
    #   # Do something when button is touched
    # end
    #
    # @example
    # rmq(my_view).on(:tap, taps_required: 2 ) do |sender, event|
    #   # Do something when event fires
    # end
    #
    # @example
    # # These both are the same
    # rmq(button).on(:tap, init: ->(recongnizer){recongnizer.numberOfTapsRequired = 2) do |sender|
    #   puts 'tapped'
    # end
    #
    # rmq(button).on(:tap, taps_required: 2) do |sender|
    #   puts 'tapped'
    # end
    def on(event, args = {}, &block)
      selected.each do |view|
        events(view).on(view, event, args, &block) 
      end

      self
    end

    # Removes events/gestures from all views selected
    #
    # @return [RMQ]
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

    def [](sdk_event_or_recognizer)
      @event_set[sdk_event_or_recognizer]
    end

    def has_events?
      !RMQ.is_blank?(@event_set)
    end

    def has_event?(sdk_event_or_recognizer)
      @event_set.include?(sdk_event_or_recognizer)
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
