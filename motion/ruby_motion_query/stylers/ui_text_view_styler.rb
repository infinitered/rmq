module RubyMotionQuery
  module Stylers
    class UITextViewStyler < UIViewStyler

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

      def font=(value) ; @view.font = value ; end
      def font ; @view.font ; end

      def corner_radius=(value = 2)
        @view.layer.cornerRadius = value
      end

      def corner_radius
        @view.layer.cornerRadius
      end

      def border_width=(value)
        @view.layer.borderWidth = value
      end

      def border_width
        @view.layer.borderWidth
      end      

    end
  end
end
