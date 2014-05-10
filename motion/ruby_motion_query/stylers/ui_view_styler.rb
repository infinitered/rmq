module RubyMotionQuery
  module Stylers

    TEXT_ALIGNMENTS = {
      left: NSTextAlignmentLeft,
      center: NSTextAlignmentCenter,
      right: NSTextAlignmentRight,
      justified: NSTextAlignmentJustified,
      natural: NSTextAlignmentNatural
    }

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
          f.size.height = h[:h] || h[:height] || f.size.height

          if sv = @view.superview
            if fr = (h[:from_right] || h[:fr])
              f.origin.x = sv.bounds.size.width - f.size.width - fr
            end

            if fb = (h[:from_bottom] || h[:fb])
              f.origin.y = sv.bounds.size.height - f.size.height - fb
            end
          end

          @view.frame = f
        else
          @view.frame = value
        end
      end
      def frame
        @view.frame
      end

      # Sets the frame using the Window's coordinates
      def absolute_frame=(value)
        self.frame = value

        f = @view.frame
        window_point = @view.convertPoint(f.origin, fromView: nil)
        f.origin.x += window_point.x
        f.origin.y += window_point.y
        @view.frame = f
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
        if sv = @view.superview
          self.top = sv.bounds.size.height - self.height - value
        end
      end
      def from_bottom
        if sv = @view.superview
          sv.bounds.size.height - self.top
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

      def opacity=(value)
        @view.layer.opacity = value
      end
      def opacity
        @view.layer.opacity
      end

      def border_width=(value)
        @view.layer.borderWidth = value
      end
      def border_width
        @view.layer.borderWidth
      end

      def border_color=(value)
        if value.is_a?(UICachedDeviceRGBColor)
          @view.layer.setBorderColor(value.CGColor)
        else
          @view.layer.setBorderColor value
        end
      end

      def border_color
        @view.layer.borderColor
      end

      def corner_radius=(value = 2)
        @view.layer.cornerRadius = value
      end

      def corner_radius
        @view.layer.cornerRadius
      end

      def masks_to_bounds=(value)
        @view.layer.masksToBounds = value
      end

      def masks_to_bounds
        @view.layer.masksToBounds
      end

    end
  end
end
