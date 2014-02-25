module RubyMotionQuery
  module Stylers

    # When you create a styler, always inherit UIViewStyler
    class UIViewStyler
      def initialize(view)
        @view = view
      end

      # If a view is reset, all state should be reset as well
      def view=(value)
        @view = value
      end
      def view
        @view
      end

      def view_has_been_styled?
        !@view.rmq_data.style_name.nil?
      end

      def superview
        @view.superview || rmq(@view).root_view || rmq.window
      end
      alias :parent :superview

      def super_height
        @view.superview.frame.size.height
      end

      def super_width
        @view.superview.frame.size.width
      end

      def tag(tags)
        rmq(@view).tag(tags)
      end

      def frame=(value)
        if value == :full # Thanks teacup for the name
          @view.frame = self.superview.bounds
        elsif value.is_a?(Hash)
          f = @view.frame
          h = value

          f.origin.x = h[:l] || h[:left] || f.origin.x
          f.origin.y = h[:t] || h[:top] || f.origin.y
          f.size.width = h[:w] || h[:width] || f.size.width
          f.size.height =h[:h] || h[:height] || f.size.height

          @view.frame = f
        else
          @view.frame = value
        end
      end
      def frame
        @view.frame
      end

      def padded=(value)
        if value.is_a?(Hash)
          h = value
          h[:l] ||= (h[:left] || 0)
          h[:t] ||= (h[:top] || 0)
          h[:r] ||= (h[:right] || 0)
          h[:b] ||= (h[:bottom] || 0)

          sbounds = self.superview.bounds

          value = [
            [h[:l], h[:t]],
            [
              sbounds.size.width - h[:l] - h[:r],
              sbounds.size.height - h[:t] - h[:b]
            ]]

          @view.frame = value
        end
      end

      def left=(value)
        f = @view.frame
        f.origin.x = value
        @view.frame = f
      end
      def left
        @view.origin.x
      end
      alias :x :left

      def top=(value)
        f = @view.frame
        f.origin.y = value
        @view.frame = f
      end
      def top
        @view.origin.y
      end
      alias :y :top

      def width=(value)
        f = @view.frame
        f.size.width = value
        @view.frame = f
      end
      def width
        @view.size.width
      end

      def height=(value)
        f = @view.frame
        f.size.height = value
        @view.frame = f
      end
      def height
        @view.size.height
      end

      def bottom=(value)
        self.top = value - self.height
      end
      def bottom
        self.top + self.height
      end

      def from_bottom=(value)
        if superview = @view.superview
          self.top = superview.bounds.size.height - self.height - value
        end
      end
      def from_bottom
        if superview = @view.superview
          superview.bounds.size.height - self.top
        end
      end

      def right=(value)
        self.left = value - self.width
      end
      def right
        self.left + self.width
      end

      def from_right=(value)
        if superview = @view.superview
          self.left = superview.bounds.size.width - self.width - value
        end
      end
      def from_right
        if superview = @view.superview
          superview.bounds.size.width - self.left
        end
      end

      def center=(value)
        @view.center = value
      end
      def center
        @view.center
      end

      def center_x=(value)
        c = @view.center
        c.x = value
        @view.center = c
      end
      def center_x
        @view.center.x
      end

      def center_y=(value)
        c = @view.center
        c.y = value
        @view.setCenter c
      end
      def center_y
        @view.center.y
      end

      # param can be :horizontal, :vertical, :both
      def centered=(option)
        if parent = @view.superview
          case option
          when :horizontal
            # Not using parent.center.x here for orientation
            self.center_x = parent.bounds.size.width / 2
          when :vertical
            self.center_y = parent.bounds.size.height / 2
          else
            @view.center = [parent.bounds.size.width / 2, parent.bounds.size.height / 2]
          end
        end
      end

      def background_color=(value)
        @view.setBackgroundColor value
      end
      def background_color
        @view.backgroundColor
      end

      def background_image=(value)
        @view.setBackgroundColor UIColor.colorWithPatternImage(value)
      end

      def z_position=(index)
        @view.layer.setZPosition index
      end
      def z_position
        @view.layer.zPosition
      end

      def opaque=(value)
        @view.layer.setOpaque value
      end
      def opaque
        @view.layer.isOpaque
      end

      def hidden=(value)
        @view.setHidden value
      end
      def hidden
        @view.isHidden
      end

      def enabled=(value)
        @view.setEnabled value
      end
      def enabled
        @view.enabled
      end

      def scale=(amount)
        if amount == 1.0
          @view.transform = CGAffineTransformIdentity
        else
          if amount.is_a?(NSArray)
            width = amount[0]
            height = amount[1]
          else
            height = amount
            width = amount
          end

          @view.transform = CGAffineTransformMakeScale(width, height)
        end
      end

      def rotation=(new_angle)
        radians = new_angle * Math::PI / 180
        @view.transform = CGAffineTransformMakeRotation(radians)
      end

      def content_mode=(value)
        @view.setContentMode value
      end
      def content_mode
        @view.contentMode
      end

      def clips_to_bounds=(value)
        @view.clipsToBounds = value
      end
      def clips_to_bounds
        @view.clipsToBounds
      end

      def tint_color=(value)
        @view.tintColor = value if @view.respond_to?('setTintColor:')
      end
      def tint_color ; @view.tintColor ; end

      def layer
        @view.layer
      end

    end
  end
end
