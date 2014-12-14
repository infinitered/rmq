class ApplicationStylesheet < RubyMotionQuery::Stylesheet
  PADDING = 10

  def application_setup
    font_family = 'Helvetica Neue'
    font.add_named :large,    font_family, 36
    font.add_named :medium,   font_family, 24
    font.add_named :small,    font_family, 11

    color.add_named :translucent_black, color(0, 0, 0, 0.4)
    color.add_named :battleship_gray,   '#7F7F7F'
  end

  def label(st)
    st.background_color = color.clear
  end

end
