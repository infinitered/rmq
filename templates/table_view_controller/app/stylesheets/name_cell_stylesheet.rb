module <%= @name_camel_case %>CellStylesheet
  def <%= @name %>_cell_height
    80
  end

  def <%= @name %>_cell(st)
    # Style overall cell here
    st.background_color = color.random
  end

  def cell_label(st)
    st.color = color.black
  end
end
