module RubyMotionQuery
  module Stylers

    class UISwitchStyler < UIControlStyler
      def on=(value) ; @view.setOn(value) ; end
      def on ; @view.isOn ; end
    end

  end
end
