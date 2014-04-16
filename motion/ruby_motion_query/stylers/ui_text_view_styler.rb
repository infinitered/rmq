module RubyMotionQuery
  module Stylers
    class UITextViewStyler < UIViewStyler

      def font=(value) ; @view.font = value ; end
      def font ; @view.font ; end

    end
  end
end
