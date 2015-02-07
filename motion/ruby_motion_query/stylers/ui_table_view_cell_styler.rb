module RubyMotionQuery
  module Stylers

    class UITableViewCellStyler < UIViewStyler

      def accessory_type=(value)
        @view.accessoryType = value
      end

      def accessory_type
        @view.accessoryType
      end

      def accessory_view=(value)
        @view.accessoryView = value
      end

      def accessory_view
        @view.accessoryView
      end

      def text_color ; @view.textLabel.textColor ; end
      def text_color=(v) ; @view.textLabel.textColor = v ; end
      alias :color :text_color
      alias :color= :text_color=

      def font ; @view.textLabel.font ; end
      def font=(v) ; @view.textLabel.font = v ; end

      def selection_style ; @view.selectionStyle ; end
      def selection_style=(v) ; @view.selectionStyle = v ; end

    end

  end
end