class Section < UIView

  def rmq_created_or_appended
    rmq.append(UILabel, :section_title)

    rmq.append(UILabel, :section_enabled_title)

    rmq.append(UISwitch, :section_enabled).on(:change) do |sender|
      style = sender.isOn ? :section_button_enabled : :section_button_disabled
      buttons = rmq(sender).parent.find(UIButton).apply_style(style)
    end

    rmq.append(UIButton, :start_spinner).on(:tap) do |sender|
      rmq.animations.start_spinner
    end

    rmq.append(UIButton, :stop_spinner).on(:tap) do |sender|
      rmq.animations.stop_spinner
    end
  end

end
