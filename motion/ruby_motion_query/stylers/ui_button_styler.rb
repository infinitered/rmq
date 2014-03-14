module RubyMotionQuery
  module Stylers
    class UIButtonStyler < UIControlStyler

      def text=(value)
        @view.setTitle(value, forState: UIControlStateNormal)
      end
      def text
        @view.title
      end

      def font=(value) ; @view.titleLabel.font = value ; end
      def font ; @view.titleLabel.font ; end

      def color=(value)
        @view.setTitleColor(value, forState: UIControlStateNormal)
      end
      def color
        @view.titleColor
      end

      def tint_color=(value)
        @view.tintColor = value
      end
      def tint_color
        @view.tintColor
      end

      def image=(value)
        self.image_normal = value
      end
      def image_normal=(value)
        @view.setImage value, forState: UIControlStateNormal
      end

      def image_highlighted=(value)
        @view.setImage value, forState: UIControlStateHighlighted
      end

      def background_image_normal=(value)
        @view.setBackgroundImage value, forState: UIControlStateNormal
      end

      def background_image_highlighted=(value)
        @view.setBackgroundImage value, forState: UIControlStateHighlighted
      end

    end
  end
end
