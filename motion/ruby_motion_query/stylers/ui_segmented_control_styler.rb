module RubyMotionQuery
  module Stylers
    class UISegmentedControlStyler < UIControlStyler

      def prepend_segments=(value)
        if value.class == Array
          value.each_with_index do |title, index|
            @view.insertSegmentWithTitle(title, atIndex:index, animated:false)
          end
        elsif value.class == String
          @view.insertSegmentWithTitle(title, atIndex:index, animated:false)
        else
          raise "#{__method__} takes an array or string."
        end
      end
      alias :unshift= :prepend_segments=

    end
  end
end