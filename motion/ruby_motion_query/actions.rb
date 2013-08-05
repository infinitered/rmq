module RubyMotionQuery
  class RMQ
    def attr(new_settings)
      selected.each do |view|
        new_settings.each do |k,v|
          view.send "#{k}=", v
        end
      end
      self
    end

    def send(method, args = nil)
      selected.each do |view|
        if args
          view.__send__ method, args
        else
          view.__send__ method
        end
      end
      self
    end

    # Sets the last selected view as the first responder
    #
    # @example
    #   rmq(my_view).next(UITextField).focus
    def focus
      unless RMQ.is_blank?(selected)
        selected.last.becomeFirstResponder
      end
      self
    end
    alias :become_first_responder :focus

    def hide
      selected.each { |view| view.hidden = true }
      self
    end

    def show
      selected.each { |view| view.hidden = false }
      self
    end

    def toggle
      selected.each { |view| view.hidden = !view.hidden? }
      self
    end

    def toggle_enabled
      selected.each { |view| view.enabled = !view.enabled? }
      self
    end

  end
end
