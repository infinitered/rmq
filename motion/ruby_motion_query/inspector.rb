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
      @selected_outline_color = rmq.color.from_rgba(202,34,250,0.7).CGColor
      @view_background_color = rmq.color.from_rgba(34,202,250,0.4).CGColor
      @view_selected_background_color = rmq.color.from_rgba(202,34,250,0.4)
      @text_color = rmq.color.from_rgba(0,0,0,0.9).CGColor
      @light_text_color = rmq.color.from_rgba(0,0,0,0.2).CGColor
      @fill_color = rmq.color.from_rgba(34,202,250,0.1).CGColor
      @row_fill_color = rmq.color.from_rgba(187,197,209,0.2).CGColor
      @column_fill_color = rmq.color.from_rgba(213,53,82,0.1).CGColor
      @background_color = rmq.color.from_rgba(255,255,255,0.9)
      @toolbox_background_color = rmq.color.clear
      @view_scale = 0.85

      @dimmed = true
      @views_outlined = true

      @selected_views = []

      root_view = rmq.root_view
      q = rmq(self)

      tq = rmq(window).append(UIView).tag(:inspector_toolbox).style do |st|
        #st.frame = {from_bottom: 0, w: rmq.device.width, h: 90}
        st.frame = :full
        st.background_color = @toolbox_background_color
        #st.background_color =rmq.color.from_rgba(0,0,255,0.1)
        st.z_position = 900
      end
      #.on(:tap){|sender| self.nextResponder}
      @toolbox = tq.get

      q.enable_interaction.on(:tap) do |sender, rmq_event|
        select_at rmq_event.location_in(sender)
      end

      q.style do |st|
        st.hidden = true
        st.frame = :full
        #st.frame = {l: -20, t: -20, w: RMQ.device.screen_width + 40, h: RMQ.device.screen_height + 40}
        st.background_color = rmq.color.clear
        st.z_position = 100
        st.scale = @view_scale
      end

      rmq(rmq.root_view).animate(
        animations: ->(q_back) do 
          q_back.style do |st| 
            st.scale = @view_scale
            st.frame = {t: 20, left: 0}
          end
          #q_back.get.bounds = [-20, -20]
          #q.get.bounds = q_back.get.bounds
        end,
        after: ->(finished, q) do 
          rmq(window).find(InspectorView).animations.fade_in
          dim_nav
          create_overlay
        end
      )

      q.get.frame = rmq.root_view.frame

      #rmq(self).disable_interaction

      tq.append(UIButton).on(:tap) do |sender|
        rmq.animate do |foo|
          rmq(rmq.root_view).style do |st| 
            st.scale = 1.0
            st.frame = {l: 0, t: 0}
          end
        end

        rmq(rmq.window).find(InspectorView).animations.drop_and_spin(after: ->(finished, inner_q){inner_q.remove})
        rmq(rmq.window).find(@toolbox).remove
        rmq(rmq.view_controller.navigationController).style{|st| st.opacity = 1.0}
        remove_overlay
        show_nav_in_all_its_glory
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

      tq.disable_interaction.find(UIButton).enable_interaction.distribute :horizontal, margin: 5

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
        st.hidden = true
        st.frame = :full
        st.background_color = @background_color
        st.z_position = 999
      end.animations.fade_in
    end

    def remove_overlay
      rmq(rmq.root_view).find(:inspector_overlay).animations.fade_out(after: ->(did_finish, q){ q.remove })
    end

    def dim_nav
      rmq(rmq.view_controller.navigationController.navigationBar).animate do |q|
        q.style{|st| st.opacity = 0.0}
      end
    end

    def show_nav_in_all_its_glory
      rmq(rmq.view_controller.navigationController.navigationBar).style{|st| st.opacity = 1.0}
    end

    def select_at(tapped_at)
      @selected_views = []
      tq = rmq(@toolbox)
      tq.find(:selected_view).remove
      root_view = rmq.root_view

      @selected.each do |view|
        rect = view.convertRect(view.bounds, toView: root_view)
        #rect = rmq(view).location_in(root_view)
        if CGRectContainsPoint(rect, tapped_at)
          @selected_views << view
          tq.append(UIImageView).tag(:selected_view).style do |st|
            st.frame = {t: ((@selected_views.length - 1) * 30) + 18, from_right: 3, w: 40, h: 25}
            st.view.contentMode = UIViewContentModeScaleAspectFit
            image = rmq.image.from_view(view)
            #st.font = rmq.font.system(9)
            #st.text = view.inspect
            #st.number_of_lines = 0
            #image.setContentMode UIViewContentModeScaleAspectFit
            #image.resizingMode = UIImageResizingModeStretch
            st.image = image
            st.background_color = rmq.color.from_hex('e29ff5') 

 
          end.animations.sink_and_throb
          #rmq(view).animations.sink_and_throb
        end
      end

      rmq(@selected_views).log
      redisplay
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

        rmq(@selected).each do |view|
          rec = view.frame
          rec.origin = rmq(view).location_in(root_view)
          #rec.origin = view.origin
          
          if @selected_views.include?(view)
            CGContextSetFillColorWithColor(context, @view_selected_background_color.CGColor)
            CGContextSetStrokeColorWithColor(context, @selected_outline_color)
          else
            CGContextSetFillColorWithColor(context, @view_background_color)
            CGContextSetStrokeColorWithColor(context, @outline_color)
          end
          
          if @dimmed
            CGContextFillRect(context, rec)
          end

          CGContextStrokeRect(context, rec)

          CGContextSetFillColorWithColor(context, @text_color)

          text = ":#{view.rmq_data.style_name}"
          CGContextShowTextAtPoint(context, rec.origin.x + 1, rec.origin.y + 7, text, text.length)

          text = "l: #{view.frame.origin.x}, t: #{view.frame.origin.y}"
          CGContextShowTextAtPoint(context, rec.origin.x + 1, rec.origin.y + 16, text, text.length)
        end
      end
    end

  end
end


