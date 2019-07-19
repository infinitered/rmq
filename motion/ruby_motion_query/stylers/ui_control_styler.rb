module RubyMotionQuery
  module Stylers

    class UIControlStyler < UIViewStyler
      def content_vertical_alignment=(value)
        @view.contentVerticalAlignment = CONTENT_VERTICAL_ALIGNMENTS[value] || value
      end

      def content_vertical_alignment
        @view.contentVerticalAlignment
      end

      def content_horizontal_alignment=(value)
        @view.contentHorizontalAlignment = CONTENT_HORIZONTAL_ALIGNMENTS[value] || value
      end

      def content_horizontal_alignment
        @view.contentHorizontalAlignment
      end

      def selected=(value)
        @view.selected = value
      end

      def selected
        @view.isSelected
      end

      def highlighted=(value)
        @view.highlighted = value
      end

      def highlighted
        @view.isHighlighted
      end

      def state
        @view.state
      end
    end

  end
end
