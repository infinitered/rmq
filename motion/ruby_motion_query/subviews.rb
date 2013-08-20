# See traversing.rb and selectors.rb for finding and traversing subviews
module RubyMotionQuery
  class RMQ

    # @return [RMQ]
    def remove
      selected.each { |view| view.removeFromSuperview }
      self
    end

    # @return [RMQ]
    def add_subview(view_or_constant, opts={})
      subviews_added = []
      style = opts[:style]

      selected.each do |selected_view|
        created = false

        if view_or_constant.is_a?(UIView)
          new_view = view_or_constant
        else
          created = true
          new_view = create_view(view_or_constant)
        end

        subviews_added << new_view
        if at_index = opts[:at_index]
          selected_view.insertSubview(new_view, atIndex: at_index)
        elsif below_view = opts[:below_view]
          selected_view.insertSubview(new_view, belowSubview: below_view)
        else
          selected_view.addSubview(new_view)
        end

        if self.stylesheet
          apply_style_to_view(new_view, style) if style
        end

        new_view.rmq_did_create if created
      end

      RMQ.create_with_array_and_selectors(subviews_added, selectors, @context)
    end
    alias :insert :add_subview

    # @return [RMQ]
    def append(view_or_constant, style=nil)
      add_subview(view_or_constant, style: style)
    end

    # @return [RMQ]
    def unshift(view_or_constant, style = nil)
      add_subview view_or_constant, style: style, at_index: 0
    end
    alias :prepend :unshift

    protected

    def create_view(klass)
      if klass == UIButton
        klass.buttonWithType(UIButtonTypeCustom).tap do |o|
          o.hidden = false
          o.opaque = true
        end
      else
        klass.alloc.initWithFrame(CGRectZero).tap do |o|
          o.hidden = false
          o.opaque = true
        end
      end
    end

  end
end
