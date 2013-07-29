class MainStylesheet < ApplicationStylesheet
  def setup
    # Add sytlesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb
  end

  def root_view(st)
    st.background_color = color.white
  end

  def logo(st)
    st.frame = {t: 10, w: 200, h: 96}
    st.centered = :horizontal
    st.image = image.resource('logo')
  end

  def title_label(st)
    label st # stack styles
    st.frame = {l: PADDING, t: 120, w: 200, h: 20}
    st.text = 'Test label'
    st.color = color.from_rgba(34, 132, 198, 1.0)
    st.font = font.medium
  end

  def make_labels_blink(st)
    st.frame = {t: 120, w: 150, h: 20}
    st.from_right = PADDING

    # ipad? (and landscape?, etc) is just a convenience methods for
    # rmq.device.ipad?

    # Here is a complete example of different formatting for orientatinos
    # and devices
    #  if ipad?
    #    if landscape?
    #      st.frame = {l: 20, t: 120, w: 150, h: four_inch? ? 20 : 30}
    #    else
    #      st.frame = {l: 90, t: 120, w: 150, h: four_inch? ? 25 : 35}
    #    end
    #  else
    #    if landscape?
    #      st.frame = {l: 20, t: 20, w: 150, h: four_inch? ? 22 : 32}
    #    else
    #      st.frame = {l: 90, t: 20, w: 150, h: four_inch? ? 30 : 40}
    #    end
    #  end

    # If you don't want something to be reapplied during orientation
    # changes (assuming you're reapplying durring orientation changes
    # in your controller, it's not automatic)
    unless st.view_has_been_styled?
      st.text = 'Blink labels'
      st.font = font.system(10)
      st.color = color.white
      st.background_color = color.from_hex('ed1160')
    end
  end

  def make_buttons_throb(st)
    st.frame = {t: 150, w: 150, h: 20}
    st.from_right = PADDING
    st.text = 'Throb buttons'
    st.color = color.black
  end

  def section(st)
    st.frame = {w: 270, h: 110}

    if landscape? && iphone?
      st.left = PADDING
    else
      st.centered = :horizontal
    end

    st.from_bottom = PADDING

    st.z_position = 1
    st.background_color = color.battleship_gray
  end

  def section_label(st)
    label st
    st.color = color.white
  end

  def section_title(st)
    section_label st
    st.frame = {l: PADDING, t: PADDING, w: 150, h: 20}
    st.text = 'Section title'
  end

  def section_enabled(st)
    label st
    st.frame = {l: PADDING, t: 30}
    st.on = true
  end

  def section_enabled_title(st)
    section_label st
    st.frame = {l: 93, t: 34, w: 150, h: 20}
    st.text = 'Enabled'
  end

  def section_buttons(st)
    st.frame = {l: PADDING, t: 64, w: 120, h: 40}
    st.background_color = color.black
    section_button_enabled st
  end

  def start_spinner(st)
    section_buttons st
    st.text = 'Start spinner'
  end

  def stop_spinner(st)
    section_buttons st
    st.from_right = PADDING
    st.text = 'Stop spinner'
  end

  def section_button_disabled(st)
    st.enabled = false
    st.color = color.dark_gray
  end

  def section_button_enabled(st)
    st.enabled = true
    st.color = color.white
  end

  def animate_move(st)
    st.scale = 1.0
    st.frame = {t: 180, w: 150, h: 20}
    st.from_right = PADDING
    st.text = 'Animate move and scale'
    st.font = font.system(10)
    st.color = color.white
    st.background_color = color.from_hex('ed1160')
    st.z_position = 99
    st.color = color.white
  end

  def overlay(st)
    st.frame = :full 
    st.background_color = color.translucent_black
    st.hidden = true
    st.z_position = 99
  end

  def benchmarks_results_wrapper(st)
    st.hidden = true
    st.frame = {w: app_width - 20, h: 120}
    st.centered = :both
    st.background_color = color.white
    st.z_position = 100
  end

  def benchmarks_results_label(st)
    label st
    st.padded = {l: 10, t: 10, b:10, r: 10}
    st.text_alignment = :left
    st.color = color.black
    st.font = font.system(10)

    # If the styler doesn't have the method, you can add it or
    # just use st.view to get the actual object
    st.view.numberOfLines = 0
    st.view.lineBreakMode = NSLineBreakByWordWrapping
  end

  def run_benchmarks(st)
    st.frame = {l: PADDING, t: 150, w: 130, h: 20}
    st.text = 'Run benchmarks'
    st.font = font.system(11)
    st.color = color.white
    st.enabled = true
    st.background_color = color.from_hex('faa619')
  end

  def run_benchmarks_disabled(st)
    st.enabled = false
    st.color = color.from_hex('de8714')
  end

  def benchmark(st)
    st.hidden = false
    st.text = 'foo'
    st.color = color.white
    st.left = 10
  end

end
