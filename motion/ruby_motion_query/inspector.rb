module RubyMotionQuery
  class RMQ
    def inspector
      existing = rmq(window).find(InspectorView)
      if existing.length > 0
        existing.remove
      end

      rmq(window).append(InspectorView).get.update(selected)
      self
    end
  end

  class InspectorView < UIView

    def rmq_build
      @outline_color = rmq.color.from_rgba(34,202,250,0.5).CGColor
      @text_color = rmq.color.from_rgba(0,0,0,0.5).CGColor
      @fill_color = rmq.color.from_rgba(34,202,250,0.1).CGColor
      @background_color = rmq.color.from_rgba(255,255,255,0.9)

      @dimmed = true
      @views_outlined = true

      q = rmq(self)
      q.style do |st|
        st.hidden = true
        st.frame = :full
        #st.frame = {l: -20, t: -20, w: RMQ.device.screen_width + 40, h: RMQ.device.screen_height + 40}
        st.background_color = @background_color
        st.scale = 3.0
      end

      #rmq(self).disable_interaction
      rmq(self).on(:tap) do |sender|
        redisplay
        rmq(self).animations.sink_and_throb
      end

      q.append(UIButton).on(:tap) do |sender|
        q.animations.drop_and_spin(after: ->(inner_q, finished){inner_q.remove})
      end.style do |st|
        st.frame = {l: 5, from_bottom: 2, w: 30, h: 12}
        st.text = 'close'
        st.font = rmq.font.system(7)
        st.background_color = rmq.color.red
      end

      q.append(UIButton).on(:tap) do |sender|
        @draw_grid = !@draw_grid
        redisplay
      end.style do |st|
        st.frame = {l: 40, from_bottom: 2, w: 30, h: 12}
        st.text = 'grid'
        st.font = rmq.font.system(7)
        st.background_color = rmq.color.red
      end

      q.append(UIButton).on(:tap) do |sender|
        @dimmed = !@dimmed

        rmq(sender).closest(InspectorView).style do |st|
          st.background_color = @dimmed ? @background_color : rmq.color.clear
        end

        redisplay
      end.style do |st|
        st.frame = {l: 75, from_bottom: 2, w: 30, h: 12}
        st.text = 'dim'
        st.font = rmq.font.system(7)
        st.background_color = rmq.color.red
      end

      q.append(UIButton).on(:tap) do |sender|
        @views_outlined = !@views_outlined

        redisplay
      end.style do |st|
        st.frame = {l: 110, from_bottom: 2, w: 50, h: 12}
        st.text = 'outline views'
        st.font = rmq.font.system(7)
        st.background_color = rmq.color.red
      end

      #self.contentMode = UIViewContentModeRedraw
      #self.autoresizesSubviews = true
      #self.autoresizingMask= UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight
    end

    def redisplay
      self.setNeedsDisplay
      # TODO make a rmq(self).redraw action
    end

    def update(selected)
      @selected = selected
      self.setNeedsDisplay
      rmq(self).animations.land_and_sink_and_throb
    end

    def drawRect(rect)
      super

      return unless @selected

      screen_height = RMQ.device.screen_height

      context = UIGraphicsGetCurrentContext()
      CGContextSetStrokeColorWithColor(context, @outline_color)
      CGContextSetFillColorWithColor(context, @fill_color)
      CGContextSetLineWidth(context, 1.0)
      CGContextSelectFont(context, 'Courier New', 8, KCGEncodingMacRoman)

      # Fixes upside down issue
      CGContextSetTextMatrix(context, CGAffineTransformMake(1.0,0.0, 0.0, -1.0, 0.0, 0.0))

      w = rmq.window

      if @draw_grid
        grid = rmq.stylesheet.grid
        #grid.column_rights.each do |x|
          #CGContextFillRect(context, [[x,0],[1, screen_height]])
        #end

        grid.column_lefts.each do |x|
          CGContextFillRect(context, [[x,0],[grid.column_width, screen_height]])
        end

        grid.column_lefts.each do |x|
          CGContextFillRect(context, [[x,0],[1, screen_height]])
        end
      end

      if @views_outlined
        CGContextSetFillColorWithColor(context, @text_color)

        rmq(@selected).each do |view|

          #rect = Rect.frame_for_view(view)
          #text = rect.inspect

          rec = view.frame
          rec.origin = rmq(view).location_in(w)
          
          CGContextStrokeRect(context, rec)


          text = "l: #{view.frame.origin.x}, t: #{view.frame.origin.y}"
          CGContextShowTextAtPoint(context, rec.origin.x + 1, rec.origin.y + 7, text, text.length)

          text = "#{view.rmq_data.style_name}"
          CGContextShowTextAtPoint(context, rec.origin.x + 1, rec.origin.y + 16, text, text.length)

          #CGContextSetTextDrawingMode(context, kCGTextFill);
          #CGContextSetRGBFillColor(@ctx, r, g, b, a)
          #CGContextSetFillColorWithColor(context, @outline_color)
          #CGContextStrokePath(context);
        end
      end
    end

  end
end


