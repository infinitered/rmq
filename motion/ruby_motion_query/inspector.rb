module RubyMotionQuery
  class RMQ
    def inspector
      existing = rmq(window).find(InspectorView)
      if existing.length > 0
        existing.remove
      end
      
      puts 'The currently selected views will be assigned to $q'

      rmq(window).append(InspectorView).get.update(selected)
      self
    end
  end

  class InspectorView < UIView
    # A note about this code. InspectorView will be sitting in the Window, not 
    # the current controller. So when you do this rmq(UIButton), that is on the 
    # current controller. rmq(self).find(UIButton) would be the buttons in the
    # inspector.

    def rmq_build
      @self_rmq = rmq(self)

      # Storing the original stylesheet, so I can remove it, use our own, then
      # put it back when we close the inspector, a bit of hackery here
      @puppets_stylesheet = rmq.stylesheet

      rmq.stylesheet = InspectorStylesheet
      @self_rmq.apply_style(:inspector_view)
      
      @hud = @self_rmq.append(InspectorHud, :hud).on(:tap) do |sender, rmq_event|
        select_at rmq_event.location_in(sender)
      end.get

      root_view = rmq.root_view

      rmq(root_view).animate(
        animations: ->(q){ q.apply_style :root_view_scaled },
        after: ->(finished, q) do 
          @self_rmq.animations.fade_in
          dim_nav
        end
      )

      @stats = @self_rmq.append! UILabel, :stats

      @self_rmq.append(UIButton, :close_button).on(:touch) do |sender|
        rmq(root_view).animate(
          animations: ->(q){ q.apply_style(:root_view) },
          after: ->(finished, inner_q){ rmq.stylesheet = @puppets_stylesheet })

        @self_rmq.animations.drop_and_spin(after: ->(finished, inner_q) do 
          inner_q.remove
        end)

        @self_rmq = nil
        $q = nil
        show_nav_in_all_its_glory
      end

      @self_rmq.append(UIButton, :grid_button).on(:touch) do |sender|
        @hud.draw_grid = !@hud.draw_grid
        redisplay
      end

      @self_rmq.append(UIButton, :grid_x_button).on(:touch) do |sender|
        @hud.draw_grid_x = !@hud.draw_grid_x
        redisplay
      end

      @self_rmq.append(UIButton, :grid_y_button).on(:touch) do |sender|
        @hud.draw_grid_y = !@hud.draw_grid_y
        redisplay
      end

      @self_rmq.append(UIButton, :dim_button).on(:touch) do |sender|
        @hud.dimmed = !@hud.dimmed
        redisplay
      end

      @self_rmq.append(UIButton, :outline_button).on(:touch) do |sender|
        @hud.views_outlined = !@hud.views_outlined
        redisplay
      end

      @self_rmq.find(UIButton).distribute :horizontal, margin: 5 

      @tree_zoomed = false
      @tree_q = @self_rmq.append(UIScrollView, :tree).on(:tap) do |sender|
        zoom_tree
      end
    end

    def redisplay
      @hud.setNeedsDisplay
    end

    def update(selected)
      @hud.selected = selected

      selected.each { |view| create_tree_view(view) }

      @self_rmq.find(:selected_view).distribute(:vertical, margin: 2)
      if last = @self_rmq.find(:selected_view).last
        #@self_rmq.find(:selected_view).log
        @tree_q.get.contentSize = [40, last.frame.bottom]
      end

      redisplay
    end

    def zoom_tree
      rmq.animate do |q|
        if @tree_zoomed
          @tree_q.apply_style(:tree)
        else
          @tree_q.apply_style(:tree_zoomed)
        end

        @tree_zoomed = !@tree_zoomed
      end
    end

    def dim_nav
      rmq(rmq.view_controller.navigationController.navigationBar).animate do |q|
        q.style{|st| st.opacity = 0.0}
      end
    end

    def show_nav_in_all_its_glory
      rmq(rmq.view_controller.navigationController.navigationBar).style{|st| st.opacity = 1.0}
    end

    def select_at(tapped_at = nil)
      #@tree_q.find(:selected_view).remove
      rmq(@stats).hide

      @hud.selected_views = []
      root_view = rmq.root_view
      
      if tapped_at
        @hud.selected.each do |view|
          rect = view.convertRect(view.bounds, toView: root_view)
          if CGRectContainsPoint(rect, tapped_at)
            @hud.selected_views << view
          end
        end
      end

      set_selected
    end

    def set_selected
      if @hud.selected_views.length == 0
        #rmq(rmq.root_view).find.each{|view| create_tree_view(view)}
      else
        update_stats @hud.selected_views.first

        #@hud.selected_views.each do |view|
          #create_tree_view(view)
        #end
      end

      if @hud.selected_views.length == 0
        rmq(rmq.root_view).log :tree
      elsif @hud.selected_views.length == 1
        Rect.frame_for_view(@hud.selected_views.first).log
      else
        rmq(@hud.selected_views.first).log :tree
      end

      $q = rmq(@hud.selected_views)

      #@self_rmq.find(:selected_view).distribute(:vertical, margin: 5)
      #if last = @self_rmq.find(:selected_view).last
        #@self_rmq.find(:selected_view).log
        #@tree_q.get.contentSize = [40, last.frame.bottom]
      #end
      #rmq(rmq.window).find(UIScrollView).style{|st| st.scale = 3.0; st.height = 580}.move t:0, w: 200

      redisplay
    end

    def create_tree_view(view)
      @tree_q.append(UIImageView).tag(:selected_view).style do |st|
        if image = rmq.image.from_view(view)

          ratio = (image.size.height / image.size.width)
          if image.size.height > image.size.width
            h = 30
            w = ratio * h
          else
            w = 30
            h = ratio * w
          end

          st.view.contentMode = UIViewContentModeScaleAspectFit
          st.image = image
        else
          h = 10
          w = 30
        end

        left = 0 + ((rmq(view).parents.length - 1) * 5)

        st.frame = {l: left, w: w, h: h}

        st.border_color = rmq.color.from_rgba(34,202,250,0.7).CGColor
        st.border_width = 0.5 
        st.background_color = rmq.stylesheet.tree_node_background_color

      end.enable_interaction.on(:tap) do |sender|
        rmq(sender).animations.sink_and_throb

        @hud.selected_views = [view]
        set_selected
        zoom_tree if @tree_zoomed
      end
    end

    def update_stats(view)
      out = %(
        style_name: :#{view.rmq_data.style_name || ''}
        #{rmq(view).frame.inspect}
        #{view.class.name} - object_id: #{view.object_id.to_s}
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
        0.upto(grid.num_rows - 1) do |r|
          0.upto(grid.num_columns - 1) do |c|
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

  class TreeNodeView < UIView
    def rmq_build
      
    end
  end

  class InspectorStylesheet < Stylesheet
    attr_reader :tree_node_background_color, :selected_border_color

    def setup
      @view_scale = 0.85
      @tool_box_button_background = color.from_hex('fe5875')
      @tool_box_button_background_alt = color.from_hex('b7d95b')
      @tree_background_color = color.from_rgba(77, 77, 77, 0.9)
      #@tree_node_background_color = color.from_rgba(77, 77, 77, 0.5)
      @tree_node_background_color = rmq.color.from_rgba(34,202,250,0.4)
      @selected_border_color = rmq.color.white
      #@view_background_color = rmq.color.from_rgba(34,202,250,0.4).CGColor
      #@tree_node_background_color = rmq.color.from_rgba(202,34,250,0.7)
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

    def tree(st)
      st.scale = 1.0
      st.frame = {t: 20, fr: 0, w: 45, fb: 0}
      st.background_color = color.black
      st.content_inset = [2,2,2,2]
      #st.border_color = @tree_node_background_color.CGColor
      #st.border_width = 0
    end

    def tree_zoomed(st)
      st.scale = 2.0
      st.background_color = @tree_background_color
      st.frame = {fr: 0, t: 0, w: 165, fb: 0}
      #st.border_width = 1
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
