module RubyMotionQuery
  module Stylers

    class UIScrollViewStyler < UIViewStyler
      def paging=(value) ; @view.pagingEnabled = value ; end
      def paging ; @view.isPagingEnabled ; end

      def scroll_enabled=(value) ; @view.scrollEnabled = value ; end
      def scroll_enabled ; @view.isScrollEnabled ; end

      def direction_lock=(value) ; @view.directionalLockEnabled = value ; end
      def direction_lock ; @view.isDirectionalLockEnabled ; end

    end

  end
end
