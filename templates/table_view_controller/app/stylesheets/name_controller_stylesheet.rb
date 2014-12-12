class <%= @name_camel_case %>ControllerStylesheet < ApplicationStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def table(st)
    st.background_color = color.gray
  end

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
