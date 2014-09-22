module RubyMotionQuery
  module Stylers
    class UITextViewStyler < UIViewStyler

      def font=(value) ; @view.font = value ; end
      def font ; @view.font ; end
      def scoll_enabled=(value) ; @view.setScrollEnabled(value) ; end
      def scrol_enabled ; @view.scrollEnabled ; end
    end
  end
end
