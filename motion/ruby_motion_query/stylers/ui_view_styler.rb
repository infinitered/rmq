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
        @view.superview || rmq(@view).view_controller.view || rmq.window
      end
      alias :parent :superview

      def tag(tags)
        rmq(@view).tag(tags)
      end

      def frame=(value)
        if value == :full # Thanks teacup for the name
          @view.frame = self.superview.bounds
        elsif value.is_a?(Hash)
          f = @view.frame
          h = value
          h[:l] ||= (h[:left] || f.origin.x)
          h[:t] ||= (h[:top] || f.origin.y)
          h[:w] ||= (h[:width] || f.size.width)
          h[:h] ||= (h[:height] || f.size.width)

          @view.frame = [[h[:l], h[:t]], [h[:w], h[:h]]]
        end
      end
      def frame
        @view.frame
      end

      def padded=(value)
        #st.padded = {l: 10, t: 10, b:10, r: 10}

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
        @view.center = c
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
        @view.backgroundColor = value
      end
      def background_color
        @view.backgroundColor
      end
      
      # TODO add background_image_tiled

      def z_position=(index)
        @view.layer.zPosition = index
      end
      def z_position
        @view.layer.zPosition
      end

      def opaque=(value)
        @view.layer.opaque = value
      end
      def opaque
        @view.layer.opaque
      end

      def hidden=(value)
        @view.hidden = value
      end
      def hidden
        @view.hidden
      end

      def enabled=(value)
        @view.enabled = value
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

    end
  end
end
