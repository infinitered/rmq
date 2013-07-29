module RubyMotionQuery
  module Stylers

    class UIScrollViewStyler < UIViewStyler 
      def paging=(value) ; @view.pagingEnabled = value ; end
      def paging ; @view.isPagingEnabled ; end
    end

  end
end
