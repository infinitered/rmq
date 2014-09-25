class PresentedControllerStylesheet < ApplicationStylesheet
  # Add your view stylesheets here. You can then override styles if needed, example:
  # include FooStylesheet

  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def wrapper_view(st)
    st.frame = {l: 10, t: 120, fr: 10, fb: 100}
    st.background_color = color.yellow
  end

  def inner_view(st)
    st.frame = {l: 5, t: 10, fr: 5, fb: 10}
    st.background_color = color.blue
    st.color = color.white
    st.text = 'Inner view'
  end

  def close_controller(st)
    st.frame = 'b0:k1'
    st.text = 'Close'
    st.background_color = color.black
    st.color = color.white
  end
end
