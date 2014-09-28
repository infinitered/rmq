module RubyMotionQuery
  module Stylers
    class UITextViewStyler < UIScrollViewStyler

      def text ; view.text ; end
      def text=(v) ; view.text = v ; end

      def attributed_text ; view.attributedText ; end
      def attributed_text=(v) ; view.attributedText = v ; end

      def font ; view.font ; end
      def font=(v) ; view.font = v ; end

      def text_color ; view.textColor ; end
      def text_color=(v) ; view.textColor = v ; end
      alias :color :text_color
      alias :color= :text_color=

    end
  end
end
