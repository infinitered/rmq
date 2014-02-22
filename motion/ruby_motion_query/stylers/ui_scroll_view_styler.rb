module RubyMotionQuery
  module Stylers

    class UIScrollViewStyler < UIViewStyler
      def paging=(value) ; @view.pagingEnabled = value ; end
      def paging ; @view.isPagingEnabled ; end

      def scroll_enabled=(value) ; @view.scrollEnabled = value ; end
      def scroll_enabled? ; @view.isScrollEnabled ; end

    end

  end
end
