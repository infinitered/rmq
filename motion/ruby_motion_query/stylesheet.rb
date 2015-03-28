module RubyMotionQuery
  class RMQ

    # @return [RMQ]
    def stylesheet=(value)
      controller = self.weak_view_controller

      unless value.is_a?(RubyMotionQuery::Stylesheet)
        value = value.new(controller)
      end
      @_stylesheet = value
      controller.rmq_data.stylesheet = value
      self
    end

    # @return [RubyMotionQuery::Stylesheet]
    def stylesheet
      @_stylesheet ||= begin

        if self.weak_view_controller && (ss = self.weak_view_controller.rmq_data.stylesheet)
          ss
        elsif (prmq = self.parent_rmq) && prmq.stylesheet
          prmq.stylesheet
        end
      end
    end

    # @example
    #   rmq(view).apply_style(:style_name_here)
    #   rmq(view).apply_style(:style_name_here, :another_style, :yet_another_style)
    #   rmq(view).apply_styles(:style_name_here, :another_style, :yet_another_style) # Alias
    #
    # @return [RMQ]
    def apply_style(*style_names)
      if style_names
        selected.each do |selected_view|
          style_names.each do |style_name|
            apply_style_to_view selected_view, style_name
          end
        end
      end
      self
    end
    alias :apply_styles :apply_style

    # Pass a block to apply styles, an inline way of applynig a style
    # @example
    #   rmq(view).style{|st| st.background_color = rmq.color.blue}
    # @return [RMQ]
    def style
      selected.each do |view|
        yield(styler_for(view))
      end
      self
    end

    # @example
    #   rmq(view).styles
    #
    # @return style_names as an array
    def styles
      out = selected.map do |view|
        view.rmq_data.styles
      end
      out.flatten!.uniq!
      out
    end

    # @example
    #   foo = rmq(view).has_style?(:style_name_here)
    #
    # @return true if all selected views has the style
    def has_style?(style_name)
      selected.each do |view|
        return false unless view.rmq_data.has_style?(style_name)
      end
      true
    end

    # Reapplies all styles in order. User rmq(view).styles to see the styles applied to a view(s)
    # @example
    #   rmq.all.reapply_styles
    #   rmq(viewa, viewb, viewc).reapply_styles
    #
    # @return [RMQ]
    def reapply_styles
      selected.each do |selected_view|
        selected_view.rmq_data.styles.each do |style_name|
          apply_style_to_view selected_view, style_name
        end
      end
      self
    end

    def styler_for(view)
      # TODO should have a pool of stylers to reuse, or just assume single threaded and
      # memoize this, however if you do that, make sure the dev doesn't retain them in a var
      custom_stylers(view) || begin
        case view
        when UILabel                 then Stylers::UILabelStyler.new(view)
        when UIButton                then Stylers::UIButtonStyler.new(view)
        when UIActivityIndicatorView then Stylers::UIActivityIndicatorViewStyler.new(view)
        when UIImageView             then Stylers::UIImageViewStyler.new(view)
        when UITableView             then Stylers::UITableViewStyler.new(view)
        when UISwitch                then Stylers::UISwitchStyler.new(view)
        when UIDatePicker            then Stylers::UIDatePickerStyler.new(view)
        when UISegmentedControl      then Stylers::UISegmentedControlStyler.new(view)
        when UIRefreshControl        then Stylers::UIRefreshControlStyler.new(view)
        when UIPageControl           then Stylers::UIPageControlStyler.new(view)
        when UIProgressView          then Stylers::UIProgressViewStyler.new(view)
        when UISlider                then Stylers::UISliderStyler.new(view)
        when UIStepper               then Stylers::UIStepperStyler.new(view)
        when UITabBar                then Stylers::UITabBarStyler.new(view)
        when UITableViewCell         then Stylers::UITableViewCellStyler.new(view)
        when UITextView              then Stylers::UITextViewStyler.new(view)
        when UITextField             then Stylers::UITextFieldStyler.new(view)
        when UINavigationBar         then Stylers::UINavigationBarStyler.new(view)
        when UIScrollView            then Stylers::UIScrollViewStyler.new(view)
        # TODO, all the controls are done, but missing some views, add
        else
          if view.respond_to?(:rmq_styler)
            # If you're creating an RMQ plug-in that is a view you can set your styler by adding this method
            view.rmq_styler
          else
            if view.is_a?(UIControl)
              Stylers::UIControlStyler.new(view)
            else
              Stylers::UIViewStyler.new(view)
            end
          end
        end
      end
    end

    protected

    # Override to set your own stylers, or just open up the styler classes
    def custom_stylers(view)
    end

    def apply_style_to_view(view, style_name)
      begin
        stylesheet.public_send(style_name, styler_for(view))
        view.rmq_data.styles << style_name unless view.rmq_data.has_style?(style_name)
        view.rmq_style_applied
      rescue NoMethodError => e
        if e.message =~ /.*#{style_name.to_s}.*/
          $stderr.puts "\n[RMQ ERROR]  style_name :#{style_name} doesn't exist for a #{view.class.name}. Add 'def #{style_name}(st)' to #{stylesheet.class.name} class\n\n"
        else
          raise e
        end
      end
    end

  end

  class Stylesheet
    attr_reader :controller

    def initialize(controller)
      @controller = RubyMotionQuery::RMQ.weak_ref(controller)

      unless Stylesheet.application_was_setup
        Stylesheet.application_was_setup = true
        application_setup
      end
      setup
    end

    def application_setup
      # Override to do your overall setup for your applications. This
      # is where you want to add your custom fonts and colors
      # This only gets called once
    end

    def setup
      # Override if you need to do setup in your specific stylesheet
    end

    class << self
      attr_accessor :application_was_setup
    end

    def grid
      @grid || RMQ.app.grid
    end
    def grid=(value)
      @grid = value
    end

    # Convenience methods -------------------
    def rmq(*working_selectors)
      if @controller.nil?
        if (app = RubyMotionQuery::RMQ.app) && (window = app.window) && (cvc = app.current_view_controller)
          cvc.rmq(working_selectors)
        else
          RubyMotionQuery::RMQ.create_with_array_and_selectors([], working_selectors, self)
        end
      else
        RubyMotionQuery::RMQ.create_with_selectors(working_selectors, @controller)
      end
    end

    def device
      RMQ.device
    end

    def landscape?
      device.landscape?
    end
    def portrait?
      device.portrait?
    end

    def iphone?
      device.iphone?
    end
    def ipad?
      device.ipad?
    end

    def four_inch?
      device.four_inch?
    end

    def retina?
      device.retina?
    end

    def window
      RMQ.app.window
    end

    def device_width
      device.width
    end

    def device_height
      device.height
    end

    def screen_width
      device.screen_width
    end

    def screen_height
      device.screen_height
    end

    def content_width
      content_size.width
    end

    def content_height
      content_size.height
    end

    # Content size of the controller's rootview, if it is a
    # UIScrollView, UICollectionView, UITableView, etc
    def content_size
      if @controller.view.respond_to?(:contentSize)
        @controller.view.contentSize
      else
        CGSizeZero
      end
    end

    def image
      RMQ.image
    end

    def color(*params)
      RMQ.color(*params)
    end

    def font
      RMQ.font
    end
  end
end
