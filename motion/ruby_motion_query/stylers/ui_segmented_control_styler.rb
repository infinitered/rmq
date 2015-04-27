module RubyMotionQuery
  module Stylers
    class UISegmentedControlStyler < UIControlStyler

      def prepend_segments=(value)
        if value.class == Array
          value.each_with_index do |title, index|
            @view.insertSegmentWithTitle(title, atIndex:index, animated:false)
          end
        elsif value.class == String
          @view.insertSegmentWithTitle(value, atIndex:0, animated:false)
        else
          raise "#{__method__} takes an array or string."
        end
      end
      alias :unshift= :prepend_segments=

      def init_with_segments=(value)
        self.prepend_segments = value unless view_has_been_styled?
      end

    end
  end
end
