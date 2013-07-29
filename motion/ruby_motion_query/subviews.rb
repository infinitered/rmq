# See traversing.rb and selectors.rb for finding and traversing subviews
module RubyMotionQuery
  class RMQ

    def remove
      selected.each { |view| view.removeFromSuperview }
      self
    end

    def append(view_or_constant, style = nil)
      subviews_added = []
      selected.each do |selected_view|
        if view_or_constant.is_a?(UIView)
          new_view = view_or_constant
        else
          new_view = create_view(view_or_constant)
        end

        subviews_added << new_view
        selected_view.addSubview(new_view)

        if self.stylesheet
          apply_style_to_view(new_view, style) if style
        end
      end

      RMQ.create_with_array_and_selectors(subviews_added, selectors, @context)
    end
    alias :add_subview :append

    def insert(view, at_index, style = nil)
       # TODO
    end

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
