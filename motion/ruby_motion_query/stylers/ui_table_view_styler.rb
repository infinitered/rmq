module RubyMotionQuery
  module Stylers

    class UITableViewStyler < UIScrollViewStyler

      def separator_style=(value)
        @view.separatorStyle = (SEPARATOR_STYLES[value] || value)
      end
      def separator_style ; @view.separatorStyle ; end

      def separator_color=(value) ; @view.separatorColor = value ; end
      def separator_color ; @view.separatorColor ; end

      def allows_selection=(value) ; @view.allowsSelection = value ; end
      def allows_selection ; @view.allowsSelection ; end

      def separator_inset=(value)
        @view.separatorInset = value
      end

      def row_height=(value)
        @view.rowHeight = value
      end

      def background_image=(value)
        @view.backgroundView = UIImageView.alloc.initWithImage(value)
      end
      def background_image
        if @view.backgroundView
          @view.backgroundView.image
        else
          nil
        end
      end

      def background_color=(value)
        @view.backgroundView = nil if @view.backgroundView
        @view.setBackgroundColor value
      end

      SEPARATOR_STYLES = {
        none: UITableViewCellSeparatorStyleNone,
        single: UITableViewCellSeparatorStyleSingleLine,
        etched: UITableViewCellSeparatorStyleSingleLineEtched
      }

    end
  end
end
