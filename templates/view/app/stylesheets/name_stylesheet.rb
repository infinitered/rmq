module <%= @name_camel_case %>Stylesheet

  def <%= @name %>(st)
    st.frame = {l: 5, t: 100, w: 80, h: 40}
    st.background_color = color.light_gray

    # Style overall view here
  end

end
