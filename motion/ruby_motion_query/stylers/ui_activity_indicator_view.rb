module RubyMotionQuery
  module Stylers
    class UIActivityIndicatorViewStyler < UIViewStyler

      UI_ACTIVITY_INDICATOR_VIEW_STYLES = {
        large: UIActivityIndicatorViewStyleWhiteLarge,
        white_large: UIActivityIndicatorViewStyleWhiteLarge,
        default: UIActivityIndicatorViewStyleWhite,
        white: UIActivityIndicatorViewStyleWhite,
        gray: UIActivityIndicatorViewStyleGray
      }

      def start_animating
        @view.startAnimating
      end
      alias :start :start_animating

      def stop_animating
        @view.stopAnimating
      end
      alias :stop :stop_animating

      def is_animating?
        @view.isAnimating
      end
      alias :animating? :is_animating?

      def hides_when_stopped=(value)
        @view.hidesWhenStopped = value
      end
      def hides_when_stopped
        @view.hidesWhenStopped
      end

      def activity_indicator_style=(value)
        @view.activityIndicatorViewStyle = UI_ACTIVITY_INDICATOR_VIEW_STYLES[value] || value
      end
      def activity_indicator_style
        @view.activityIndicatorViewStyle
      end

      def color=(value)
        @view.color = value
      end
      def color
        @view.color
      end
    end
  end
end
