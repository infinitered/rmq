module RubyMotionQuery
  module Stylers

    class UIScrollViewStyler < UIViewStyler
      def paging=(value) ; @view.pagingEnabled = value ; end
      def paging ; @view.isPagingEnabled ; end

      def scroll_enabled=(value) ; @view.scrollEnabled = value ; end
      def scroll_enabled ; @view.isScrollEnabled ; end

      def direction_lock=(value) ; @view.directionalLockEnabled = value ; end
      def direction_lock ; @view.isDirectionalLockEnabled ; end

      def content_offset=(value) ; @view.contentOffset = value ; end
      def content_offset ; @view.contentOffset ; end

      def content_inset=(value) ; @view.contentInset = value ; end
      def content_inset ; @view.contentInset ; end

      def bounces=(value); @view.bounces = value; end
      def bounces; @view.bounces; end

      def content_size=(value); @view.contentSize = value; end
      def content_size; @view.contentSize; end

      def shows_horizontal_scroll_indicator=(value); @view.showsHorizontalScrollIndicator = value; end
      def shows_horizontal_scroll_indicator; @view.showsHorizontalScrollIndicator; end

      def shows_vertical_scroll_indicator=(value); @view.showsVerticalScrollIndicator = value; end
      def shows_vertical_scroll_indicator; @view.showsVerticalScrollIndicator; end

      def scroll_indicator_insets=(value); @view.scrollIndicatorInsets = value; end
      def scroll_indicator_insets; @view.scrollIndicatorInsets; end


    end

  end
end
