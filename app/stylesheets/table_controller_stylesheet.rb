class TableControllerStylesheet < ApplicationStylesheet

  include TableCellStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def table(st)
    st.background_color = color.gray
  end
end
