module RubyMotionQuery
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
