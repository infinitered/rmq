module CollectionCellStylesheet
  def cell_size
    {w: 96, h: 96}
  end

  def collection_cell(st)
    st.frame = cell_size
    st.background_color = color.random

    # Style overall view here
  end

  def title(st)
    st.frame = :full
    st.color = color.white
    st.text_alignment = :center
  end

end
