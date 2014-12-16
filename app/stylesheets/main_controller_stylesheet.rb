class MainControllerStylesheet < ApplicationStylesheet
  def setup
    # Add stylesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb

    @padding = 10
  end

  def root_view(st)
    st.background_color = color.white
  end

  def logo(st)
    st.frame = {t: 77, w: 200, h: 95.5, centered: :horizontal }
    st.image = image.resource('logo')
  end

  def button_set_button(st)
    st.frame = {fr: @padding, bp: 2 , w: 150, h: 15}
  end

  def make_labels_blink_button(st)
    st.frame = {fr: @padding, bp: 8, w: 150, h: 15}

    st.text = 'Blink labels'
    st.font = font.system(10)
    st.color = color.white
    st.background_color = color('ed1160')
  end

  def make_buttons_throb_button(st)
    st.text = 'Throb buttons'
    st.color = color.black
  end

  def animate_move_button(st)
    st.scale = 1.0
    button_set_button st
    st.text = 'Animate move and scale'
    st.font = font.system(10)
    st.color = color.white
    st.background_color = color('ed1160')
    st.z_position = 99
    st.color = color.white
  end

  def collection_button(st)
    button_set_button st
    st.background_color = color.black
    st.font = font.small
    st.text = 'Collection View'
  end

  def table_button(st)
    button_set_button st
    st.background_color = color.black
    st.font = font.small
    st.text = 'Table View'
  end

  def present_button(st)
    button_set_button st
    st.background_color = color.purple
    st.font = font.small
    st.text = 'Present controller'
  end

  def section(st)
    st.frame = {fb: @padding, w: 270, h: 110}

    if landscape? && iphone?
      st.frame = {left: @padding }
    else
      st.frame = {centered: :horizontal}
    end

    st.z_position = 1
    st.background_color = color.battleship_gray
  end

  def section_label(st)
    label st
    st.color = color.white
  end

  def section_title(st)
    section_label st
    st.frame = {l: @padding, t: @padding, w: 150, h: 20}
    st.text = 'Section title'
  end

  def section_enabled(st)
    label st
    st.frame = {l: @padding, t: 30}
    st.on = true
  end

  def section_enabled_title(st)
    section_label st
    st.frame = {l: 93, t: 34, w: 150, h: 20}
    st.text = 'Enabled'
  end

  def section_buttons(st)
    st.frame = {l: @padding, t: 64, w: 120, h: 40}
    st.background_color = color.black
    section_button_enabled st
  end

  def start_spinner(st)
    section_buttons st
    st.text = 'Start spinner'
  end

  def stop_spinner(st)
    section_buttons st
    st.frame = {from_right: @padding}
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

  def popup_section(st)
    t = (landscape? && iphone?) ? 100 : 180
    st.frame = {l: @padding, t: t, w: 100 + (@padding * 2), h: 60}
    st.background_color = color('faa619')
  end

  def open_popup(st)
    st.frame = {l: @padding, t: 30, w: 100, h: 20}
    st.text = 'Open popup'
    st.font = font.system(11)
    st.color = color('faa619')
    st.enabled = true
    st.background_color = color.white
  end

  def open_popup_disabled(st)
    st.enabled = false
    st.color = color('de8714')
  end

  def title_label(st)
    label st # stack styles
    st.frame = {l: @padding, t: @padding, w: 100, h: 15}

    st.text = 'Test label'
    st.color = color.from_rgba(34, 132, 198, 1.0)
    st.font = font.small
  end


  def overlay(st)
    st.frame = :full
    st.background_color = color.translucent_black
    st.hidden = true
    st.z_position = 99
  end

  def popup_wrapper(st)
    st.hidden = true

    st.frame = {w: screen_width - 20, h: 120}
    st.centered = :both
    st.background_color = color.white
    st.z_position = 100
  end

  def popup_text_label(st)
    label st
    st.padded = {l: 10, t: 10, b:10, r: 10}
    st.text_alignment = :left
    st.color = color.black
    st.font = font.system(10)
    st.text = "This is a Popup, woot!"

    # If the styler doesn't have the method, you can add it or
    # just use st.view to get the actual object
    st.view.numberOfLines = 0
    st.view.lineBreakMode = NSLineBreakByWordWrapping
  end

  def benchmark(st)
    st.hidden = false
    st.text = 'foo'
    st.color = color.white
    st.left = 10
  end

  def validation_section(st)
    st.background_color = color.yellow
    st.frame = 'a7:e10'
  end

  def validation_title(st)
    st.frame = 'a7:e7'
    st.text = "Validations"
    st.text_alignment = :center
  end

  def only_digits(st)
    st.placeholder = "Only Digits"
    st.frame = 'b8:d8'
    st.background_color = color.white
    st.font = rmq.font.small
    st.corner_radius = 5
    st.validation_errors = {
      digits: "Please only enter digits in this text field."
    }
  end

  def only_email(st)
    st.placeholder = "Valid Email"
    st.frame = 'b9:d9'
    st.background_color = color.white
    st.font = rmq.font.small
    st.corner_radius = 5
  end

  def invalid(st)
    st.border_color = color.red
    st.border_width = 1
  end

  def valid(st)
    st.border_color = color.green
    st.border_width = 1
  end

end
