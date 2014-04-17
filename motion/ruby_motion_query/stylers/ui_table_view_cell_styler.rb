module RubyMotionQuery
  module Stylers

    class UITableViewCellStyler < UIViewStyler 
      
      def accessory_type=(value)
        @view.accessoryType = value
      end

      def accessory_type
        @view.accessoryType
      end

    end

  end
end
