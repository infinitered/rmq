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

    # @return [RMQ]
    def apply_style(style_name)
      selected.each do |selected_view|
        apply_style_to_view selected_view, style_name
      end
      self
    end

    # @return [RMQ]
    def style()
      selected.each do |view|
        yield(styler_for(view))
      end
      self
    end

    # @return [RMQ]
    def reapply_styles
      selected.each do |selected_view|
        if style_name = selected_view.rmq_data.style_name
          apply_style_to_view selected_view, style_name
        end
      end
      self
    end

    def styler_for(view)
      # TODO should have a pool of stylers to reuse, or just assume single threaded and
      # memoize this, however if you do that, make sure the dev doesn't retain them in a var
      custom_stylers(view) || begin
        if Stylers.const_defined?("#{view.class}Styler")
          styler = Stylers.const_get("#{view.class}Styler")
          styler.new(view)
        else
          Stylers::UIViewStyler.new(view)
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
        view.rmq_data.style_name = style_name
      rescue NoMethodError => e
        if e.message =~ /.*#{style_name.to_s}.*/
          puts "\n[RMQ ERROR]  style_name :#{style_name} doesn't exist for a #{view.class.name}. Add 'def #{style_name}(st)' to #{stylesheet.class.name} class\n\n"
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

    # Convenience methods -------------------
    def rmq
      if @controller.nil?
        RMQ.new
      else
        @controller.rmq
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
      RMQ.device.four_inch?
    end

    def retina?
      RMQ.device.retina?
    end

    def window
      RMQ.app.window
    end

    def app_width
      app_size.width
    end

    def app_height
      app_size.height
    end

    def app_size
      device.screen.applicationFrame.size
    end

    def screen_width
      screen_size.width
    end

    def screen_height
      screen_size.height
    end

    def screen_size
      device.screen.bounds.size
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

    def color
      RMQ.color
    end

    def font
      RMQ.font
    end
  end
end
