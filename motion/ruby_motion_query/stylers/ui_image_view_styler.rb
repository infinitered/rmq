module RubyMotionQuery
  module Stylers

    class UIImageViewStyler < UIViewStyler
      def image=(value)
        @view.image = value
      end
      def image
        @view.image
      end
    end

  end
end
