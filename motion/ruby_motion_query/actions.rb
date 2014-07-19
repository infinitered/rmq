module RubyMotionQuery
  class RMQ

    # @return [RMQ]
    def attr(new_settings)
      selected.each do |view|
        new_settings.each do |k,v|
          view.send "#{k}=", v
        end
      end
      self
    end

    # Get or set the most common data for a particuliar view(s) in a
    # performant way (more performant than attr)
    # For example, text for UILabel, image for UIImageView
    #
    # @return [RMQ]
    def data(new_data = nil)
      if new_data
        selected.each do |view|
          case view
          when UILabel              then view.setText new_data # set is faster than =
          when UIButton             then view.setTitle(new_data, forState: UIControlStateNormal)
          when UIImageView          then view.image = new_data
          #when UITableView          then
          #when UISwitch             then
          #when UIDatePicker         then
          #when UISegmentedControl   then
          #when UIRefreshControl     then
          #when UIPageControl        then
          #when UISlider             then
          #when UIStepper            then
          #when UITabBar             then
          #when UITableViewCell      then
          when UITextView           then view.setText new_data
          when UITextField           then view.setText new_data
          #when UINavigationBar      then
          #when UIScrollView         then

          # TODO, finish
          end
        end

        self
      else
        out = selected.map do |view|
          case view
          when UILabel              then view.text
          when UIButton             then view.titleForState(UIControlStateNormal)
          when UIImageView          then view.image
          #when UITableView          then
          #when UISwitch             then
          #when UIDatePicker         then
          #when UISegmentedControl   then
          #when UIRefreshControl     then
          #when UIPageControl        then
          #when UISlider             then
          #when UIStepper            then
          #when UITabBar             then
          #when UITableViewCell      then
          when UITextView           then view.text
          when UITextField          then view.text
          #when UINavigationBar      then
          #when UIScrollView         then

          # TODO, finish
          end
        end

        out = out.first if out.length == 1
        out
      end
    end

    # Allow users to set data with equals
    #
    # @return [RMQ]
    #
    # @example
    #   rmq(my_view).data = 'some data'
    def data=(new_data)
      data(new_data)
    end

    # @return [RMQ]
    def send(method, args = nil)
      selected.each do |view|
        if view.respond_to?(method)
          if args
            view.__send__ method, args
          else
            view.__send__ method
          end
        end
      end
      self
    end

    # Sets the last selected view as the first responder
    #
    # @return [RMQ]
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

    # @return [RMQ]
    def hide
      selected.each { |view| view.hidden = true }
      self
    end

    # @return [RMQ]
    def show
      selected.each { |view| view.hidden = false }
      self
    end

    # @return [RMQ]
    def toggle
      selected.each { |view| view.hidden = !view.hidden? }
      self
    end

    # @return [RMQ]
    def toggle_enabled
      selected.each { |view| view.enabled = !view.enabled? }
      self
    end

    def enable
      selected.each { |view| view.enabled = true }
      self
    end

    def disable
      selected.each { |view| view.enabled = false }
      self
    end

    def enable_interaction
      selected.each { |view| view.userInteractionEnabled = true }
      self
    end

    def disable_interaction
      selected.each { |view| view.userInteractionEnabled = false }
      self
    end

  end
end
