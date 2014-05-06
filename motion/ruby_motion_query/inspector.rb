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

      rmq.stylesheet = InspectorStylesheet
      rmq(self).apply_style(:inspector_view)

      root_view = rmq.root_view
      self_q = rmq(self)
      
      @hud = self_q.append(InspectorHud, :hud).on(:tap) do |sender, rmq_event|
        select_at rmq_event.location_in(sender)
      end.get

      rmq(root_view).animate(
        animations: ->(q){ q.apply_style :root_view_scaled },
        after: ->(finished, q) do 
          self_q.animations.fade_in
          dim_nav
        end
      )

      @stats = self_q.append! UILabel, :stats

      self_q.append(UIButton, :close_button).on(:touch) do |sender|
        rmq(root_view).animate{|q| q.apply_style(:root_view)}

        rmq(rmq.window).find(InspectorView).animations.drop_and_spin(after: ->(finished, inner_q){inner_q.remove})
        show_nav_in_all_its_glory
      end

      self_q.append(UIButton, :grid_button).on(:touch) do |sender|
        @hud.draw_grid = !@hud.draw_grid
        redisplay
      end

      self_q.append(UIButton, :grid_x_button).on(:touch) do |sender|
        @hud.draw_grid_x = !@hud.draw_grid_x
        redisplay
      end

      self_q.append(UIButton, :grid_y_button).on(:touch) do |sender|
        @hud.draw_grid_y = !@hud.draw_grid_y
        redisplay
      end

      self_q.append(UIButton, :dim_button).on(:touch) do |sender|
        @hud.dimmed = !@hud.dimmed
        redisplay
      end

      self_q.append(UIButton, :outline_button).on(:touch) do |sender|
        @hud.views_outlined = !@hud.views_outlined
        redisplay
      end

      self_q.find(UIButton).distribute :horizontal, margin: 5 
    end

    def redisplay
      @hud.setNeedsDisplay
    end

    def update(selected)
      @hud.selected = selected
      redisplay
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

      rmq(self).find(:selected_view).remove

      @hud.selected_views = []
      root_view = rmq.root_view
      
      rmq(@stats).hide

      @hud.selected.each do |view|
        rect = view.convertRect(view.bounds, toView: root_view)
        #rect = rmq(view).location_in(root_view)
        if CGRectContainsPoint(rect, tapped_at)
          @hud.selected_views << view
          rmq(self).append(UIImageView).tag(:selected_view).style do |st|
            st.frame = {t: ((@hud.selected_views.length - 1) * 30) + 18, from_right: 3, w: 40, h: 25}
            st.view.contentMode = UIViewContentModeScaleAspectFit
            image = rmq.image.from_view(view)
            st.image = image
            st.background_color = rmq.stylesheet.selected_background_color

            update_stats view
          end.enable_interaction.on(:tap) do |sender|
            rmq(sender).animations.sink_and_throb
            rmq(view).frame.log
            update_stats view
          end.animations.sink_and_throb
          #rmq(view).animations.sink_and_throb
        end
      end

      @hud.selected_views.each{|view| Rect.frame_for_view(view).log}
      redisplay
    end

    def update_stats(view)
      out = %(
        #{view.class.name} - object_id: #{view.object_id.to_s}
        #{rmq(view).frame.inspect}
        style_name: :#{view.rmq_data.style_name || ''}
      ).strip
      rmq(@stats).show.get.text = out
    end
  end

  class InspectorHud < UIView
    attr_accessor :selected, :selected_views, :dimmed, :views_outlined, 
      :draw_grid_x, :draw_grid, :draw_grid_y

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
      @view_scale = 0.85

      @views_outlined = true
      @dimmed = true
      @selected_views = []
    end

    def drawRect(rect)
      super

      return unless @selected

      context = UIGraphicsGetCurrentContext()

      screen_height = RMQ.device.screen_height
      screen_width = RMQ.device.screen_width

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

      if @dimmed
        CGContextSetFillColorWithColor(context, @background_color.CGColor)
        CGContextFillRect(context, self.bounds)
      end

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

        @selected.each do |view|
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

  class InspectorStylesheet < Stylesheet
    attr_reader :selected_background_color
    def setup
      @view_scale = 0.85
      @tool_box_button_background = color.from_hex('fe5875')
      @tool_box_button_background_alt = color.from_hex('b7d95b')
      @selected_background_color = rmq.color.from_hex('D987F2')
      #@selected_background_color = rmq.color.from_rgba(202,34,250,0.7)
    end

    def inspector_view(st)
      st.hidden = true
      st.frame = :full
      st.background_color = color.clear
      st.z_position = 999 
      #st.scale = @view_scale
    end

    def root_view_scaled(st)
      st.scale = @view_scale
      st.frame = {t: 20, left: 0}
    end

    def root_view(st)
      st.scale = 1.0
      st.frame = {l: 0, t: 0}
    end

    def hud(st)
      st.frame = :full
      st.background_color = color.clear
      st.scale = @view_scale
      st.frame = {t: 20, left: 0}
    end

    def stats(st)
      st.frame = {from_bottom: 15, w: screen_width, h: 45}
      st.background_color = color.clear
      st.font = rmq.font.system(8)
      st.color = color.white
      st.number_of_lines = 0
    end

    def tool_box_button(st)
      st.frame = {from_bottom: 0, w: 30, h: 9}
      st.text = 'close'
      st.font = rmq.font.system(7)
      st.background_color = @tool_box_button_background
    end

    def close_button(st)
      tool_box_button(st)
      st.text = 'close'
    end

    def grid_button(st)
      tool_box_button(st)
      st.text = 'grid'
      st.background_color = @tool_box_button_background_alt
    end
    def grid_x_button(st)
      tool_box_button(st)
      st.text = 'grid-x'
      st.background_color = @tool_box_button_background_alt
    end
    def grid_y_button(st)
      tool_box_button(st)
      st.text = 'grid-y'
      st.background_color = @tool_box_button_background_alt
    end

    def dim_button(st)
      tool_box_button(st)
      st.text = 'dim'
    end

    def outline_button(st)
      tool_box_button(st)
      st.text = 'outline'
    end

  end

end
