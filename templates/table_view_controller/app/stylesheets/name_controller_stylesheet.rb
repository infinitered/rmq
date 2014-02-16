class <%= @name_camel_case %>ControllerStylesheet < ApplicationStylesheet

  include <%= @name_camel_case %>CellStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def table(st)
    st.background_color = color.gray
  end
end
