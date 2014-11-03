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

    end

  end
end