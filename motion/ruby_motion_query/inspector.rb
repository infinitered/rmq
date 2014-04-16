module RubyMotionQuery
  class InspectorView < UIView

    def rmq_build
      rmq.style do |st|
        st.hidden = true
        st.frame = :full
        st.background_color = rmq.color.clear
        st.scale = 3.0
      end
    end

    def drawRect(rect)
      super

      context = UIGraphicsGetCurrentContext()
      CGContextSetStrokeColorWithColor(context, rmq.color.red.CGColor)

      CGContextSetLineWidth(context, 4.0)

      CGContextMoveToPoint(context, 0,0)
      CGContextAddLineToPoint(context, 200, 300)
      CGContextStrokePath(context);
    end

  end
end
