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

  # This class is thrown together, it's just for debugging, so I didn't make 
  # the code very nice. TODO, make code very nice
  class InspectorView < UIView

    def rmq_build
      @outline_color = rmq.color.from_rgba(34,202,250,0.7).CGColor
      @view_background_color = rmq.color.from_rgba(34,202,250,0.4).CGColor
      @text_color = rmq.color.from_rgba(0,0,0,0.9).CGColor
      @light_text_color = rmq.color.from_rgba(0,0,0,0.2).CGColor
      @fill_color = rmq.color.from_rgba(34,202,250,0.1).CGColor
      @row_fill_color = rmq.color.from_rgba(187,197,209,0.2).CGColor
      @column_fill_color = rmq.color.from_rgba(213,53,82,0.1).CGColor
      @background_color = rmq.color.from_rgba(255,255,255,0.9)
      @view_scale = 0.95

      rmq(rmq.view_controller.navigationController.navigationBar).style{|st| st.opacity = 0.2}

      @dimmed = true
      @views_outlined = true
      create_overlay

      q = rmq(self)
      q.style do |st|
        st.hidden = true
        st.frame = :full
        #st.frame = {l: -20, t: -20, w: RMQ.device.screen_width + 40, h: RMQ.device.screen_height + 40}
        st.background_color = rmq.color.clear
        st.z_position = 100
        st.scale = @view_scale
      end

      rmq.animate(
        animations: ->(q_back){rmq(rmq.root_view).style{|st| st.scale = @view_scale}},
        after: ->(q_back, finished){ rmq(window).find(InspectorView).animations.fade_in }
      )

      #rmq(self).disable_interaction
      q.on(:tap) do |sender|
        rotate
        #redisplay
      end

      tq = rmq(window).append(UIView).tag(:inspector_toolbox).style do |st|
        st.frame = :full
        st.background_color = rmq.color.clear
        #st.background_color =rmq.color.from_rgba(0,0,255,0.1)
        st.z_position = 900
      end
      @toolbox = tq.get

      tq.append(UIButton).on(:tap) do |sender|
        rmq.animate do |foo|
          rmq(rmq.root_view).style{|st| st.scale = 1.0}
        end

        rmq(rmq.window).find(@toolbox, InspectorView).animations.drop_and_spin(after: ->(inner_q, finished){inner_q.remove})
        rmq(rmq.view_controller.navigationController).style{|st| st.opacity = 1.0}
        remove_overlay
      end.style do |st|
        st.frame = {from_bottom: 0, w: 30, h: 9}
        st.text = 'close'
        st.font = rmq.font.system(7)
        st.background_color = rmq.color.from_hex('fe5875')
      end

      tq.append(UIButton).on(:tap) do |sender|
        @draw_grid = !@draw_grid
        redisplay
      end.style do |st|
        st.frame = {from_bottom: 0, w: 25, h: 9}
        st.text = 'grid'
        st.font = rmq.font.system(7)
        st.background_color = rmq.color.from_hex('b7d95b')
      end

      tq.append(UIButton).on(:tap) do |sender|
        @draw_grid_x = !@draw_grid_x
        redisplay
      end.style do |st|
        st.frame = {from_bottom: 0, w: 25, h: 9 }
        st.text = 'grid x'
        st.font = rmq.font.system(7)
        st.background_color = rmq.color.from_hex('b7d95b')
      end

      tq.append(UIButton).on(:tap) do |sender|
        @draw_grid_y = !@draw_grid_y
        redisplay
      end.style do |st|
        st.frame = {from_bottom: 0, w: 25, h: 9}
        st.text = 'grid y'
        st.font = rmq.font.system(7)
        st.background_color = rmq.color.from_hex('b7d95b')
      end

      tq.append(UIButton).on(:tap) do |sender|
        if @dimmed
          remove_overlay
        else
          create_overlay
        end

        @dimmed = !@dimmed

        #rmq(sender).closest(InspectorView).style do |st|
          #st.background_color = @dimmed ? @background_color : rmq.color.clear
        #end

        redisplay
      end.style do |st|
        st.frame = {from_bottom: 0, w: 20, h: 9}
        st.text = 'dim'
        st.font = rmq.font.system(7)
        st.background_color = rmq.color.from_hex('539ff4')
      end

      tq.append(UIButton).on(:tap) do |sender|
        @views_outlined = !@views_outlined

        redisplay
      end.style do |st|
        st.frame = {from_bottom: 0, w: 50, h: 9}
        st.text = 'outline views'
        st.font = rmq.font.system(7)
        st.background_color = rmq.color.from_hex('539ff4')
      end

      tq.find(UIButton).distribute :horizontal, margin: 5

      #self.transform = foo

    end

    def redisplay
      self.setNeedsDisplay
      # TODO make a rmq(self).redraw action
    end

    def update(selected)
      @selected = selected
      self.setNeedsDisplay
      #rmq(self).animations.land_and_sink_and_throb
    end

    def create_overlay
      rmq(rmq.root_view).append(UIView).tag(:inspector_overlay).style do |st|
        st.frame = :full
        st.background_color = @background_color
        st.z_position = 999
      end
    end

    def remove_overlay
      rmq(rmq.root_view).find(:inspector_overlay).remove
    end

    def drawRect(rect)
      super

      return unless @selected

      screen_height = RMQ.device.screen_height
      screen_width = RMQ.device.screen_width

      context = UIGraphicsGetCurrentContext()
      CGContextSetStrokeColorWithColor(context, @outline_color)
      CGContextSetFillColorWithColor(context, @fill_color)
      CGContextSetLineWidth(context, 1.0)
      #CGContextSelectFont(context, 'Courier New', 7, KCGEncodingMacRoman)
      CGContextSelectFont(context, 'Helvetica', 7, KCGEncodingMacRoman)

      # Fixes upside down issue
      CGContextSetTextMatrix(context, CGAffineTransformMake(1.0,0.0, 0.0, -1.0, 0.0, 0.0))

      w = rmq.window
      grid = rmq.stylesheet.grid
      root_view = rmq.root_view

      if @draw_grid_x
        CGContextSetFillColorWithColor(context, @column_fill_color)

        grid.column_lefts.each do |x|
          CGContextFillRect(context, [[x,0],[grid.column_width, screen_height]])
          CGContextFillRect(context, [[x,0],[1, screen_height]])
        end
      end

      if @draw_grid_y
        CGContextSetFillColorWithColor(context, @row_fill_color)

        grid.row_tops.each do |y|
          CGContextFillRect(context, [[0,y],[screen_width, grid.row_height]])
          CGContextFillRect(context, [[0,y],[screen_width, 1]])
        end
      end

      if @draw_grid
        0.upto(grid.rows - 1) do |r|
          0.upto(grid.columns - 1) do |c|
            rec = grid[[c, r]]
            CGContextSetFillColorWithColor(context, @column_fill_color)
            CGContextFillRect(context, rec.to_cgrect) 
            text = "#{(c+97).chr}#{r}"
            CGContextSetFillColorWithColor(context, @light_text_color)
            CGContextShowTextAtPoint(context, rec.origin.x + 1, rec.origin.y + 5, text, text.length)
          end
        end
      end

      if @views_outlined
        CGContextSetFillColorWithColor(context, @outline_color)

        rmq(@selected).each do |view|
          rec = view.frame
          rec.origin = rmq(view).location_in(root_view)
          #rec.origin = view.origin
          
          if @dimmed
            CGContextSetFillColorWithColor(context, @view_background_color)
            CGContextFillRect(context, rec)
          end

          CGContextSetFillColorWithColor(context, @outline_color)
          CGContextStrokeRect(context, rec)

          CGContextSetFillColorWithColor(context, @text_color)

          text = ":#{view.rmq_data.style_name}"
          CGContextShowTextAtPoint(context, rec.origin.x + 1, rec.origin.y + 7, text, text.length)

          text = "l: #{view.frame.origin.x}, t: #{view.frame.origin.y}"
          CGContextShowTextAtPoint(context, rec.origin.x + 1, rec.origin.y + 16, text, text.length)
        end
      end
    end

    def rotate
      puts 'rotating'
      $o = self
      #self.layer.zPosition = 100
      #self.layer.anchorPoint =

      #@rotation_states = [0,15, 45, 15, 0, -15, -45, -15]
      @rotation_states ||= [
        [0, 0],
        [45, -20],
        [0, 20],
        [-45, 20]
      ]
      @rotation_index ||= 0

      #rmq(self).animations.sink_and_throb
      #foo = CATransform3DMakeRotation((10 * (Math::PI / 180)), 0.0, 1.0, 0.0)
      #degree = 45.0

      @rotation_index += 1
      @rotation_index = 0 if @rotation_index >= @rotation_states.length

      #@rotation = (@rotation == degree) ? 0.0 : degree

      transformation = CATransform3DIdentity
      transformation.m34 = 1.0 / -500
      transformation = CATransform3DRotate(transformation, @rotation_states[@rotation_index][0] * Math::PI / 180.0, 0.1, 1.0, 0.0)
      #transformation = CGAffineTransformScale(transformation,0.5,0.5)

      #transformation2 = CATransform3DIdentity
      ##transformation2.m34 = 1.0 / -500
      ##transformation2.m43 = 1.0 / -500 # pushes on z-axis
      #transformation2.m34 = 1.0 / -2000
      ##transformation2 = CATransform3DTranslate(transformation2, 0.0, 0.0, 0.5)


      #CATransform3D initialTransform = self.view.layer.sublayerTransform;
      #initialTransform.m34 = 1.0 / -500;
      #self.view.layer.sublayerTransform = initialTransform;
      #CGPointMake(10.0, 10.0)

      #puts "\n\n\n********************#{transformation.inspect}\n\n\n"
      #rmq.animate(animations: ->(foo) do 
      ##rmq.app.window.layer.transform = transformation
      ##self.layer.transform = CATransform3DMakeTranslation(0.0, 0.0, 20.0)
      ##rmq.root_view.layer.transform = transformation
      ##self.layer.transform = transformation2
      ##self.layer.transform = transformation
      ##rmq(self).nudge r: @rotation_states[@rotation_index]
      ##if @rotation_states[@rotation_index] == 0
      ##rmq(self).nudge r: 20 #@rotation_states[@rotation_index]
      ##else
      #rmq(self).nudge l: 20
      ##end
      #end)

      rmq.root_view.layer.transform = transformation
      #rmq(self).nudge r: @rotation_states[@rotation_index][1]

      #rmq.animate(animations: ->(foo) do 
      #rmq.app.window.layer.transform = transformation
      #end, after: ->(foo, bar) do
      ##rmq(rmq.app.window).style{|st| st.scale = 0.7}
      #end)

    end

  end
end


