module <%= @name_camel_case %>CellStylesheet
  def cell_size
    {w: 96, h: 96}
  end

  def <%= @name %>_cell(st)
    st.frame = cell_size
    st.background_color = color.random

    # Style overall view here
  end

end
