module RubyMotionQuery
  module Stylers

    class UIPageControlStyler < UIControlStyler
      def current_page; @view.currentPage; end
      def current_page=(value); @view.currentPage=value; end

      def number_of_pages; @view.numberOfPages; end
      def number_of_pages=(value); @view.numberOfPages = value; end

      def page_indicator_tint_color; @view.pageIndicatorTintColor; end
      def page_indicator_tint_color=(color); @view.pageIndicatorTintColor = color;end

      def current_page_indicator_tint_color; @view.currentPageIndicatorTintColor;end
      def current_page_indicator_tint_color=(color);@view.currentPageIndicatorTintColor = color;end

    end

  end
end
