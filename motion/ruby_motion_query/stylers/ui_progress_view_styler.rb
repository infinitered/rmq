module RubyMotionQuery
  module Stylers

    class UIProgressViewStyler < UIViewStyler

      def progress_image=(value) ; @view.progressImage = value ; end
      def progress_image ; @view.progressImage ; end

      def progress_tint_color=(value) ; @view.progressTintColor = value ; end
      def progress_tint_color ; @view.progressTintColor ; end

      def progress_view_style=(value) ; @view.progressViewStyle = value ; end
      def progress_view_style ; @view.progressViewStyle ; end

      def track_image=(value) ; @view.trackImage = value ; end
      def track_image ; @view.trackImage ; end

      def track_tint_color=(value) ; @view.trackTintColor = value ; end
      def track_tint_color ; @view.trackTintColor ; end

    end

  end
end
