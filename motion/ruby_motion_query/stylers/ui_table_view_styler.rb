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

      SEPARATOR_STYLES = {
        none: UITableViewCellSeparatorStyleNone,
        single: UITableViewCellSeparatorStyleSingleLine,
        etched: UITableViewCellSeparatorStyleSingleLineEtched
      }

    end

  end
end
