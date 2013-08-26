class Section < UIView

  def rmq_did_create(self_in_rmq)

    self_in_rmq.tap do |q|
      q.append(UILabel, :section_title)

      q.append(UILabel, :section_enabled_title)

      q.append(UISwitch, :section_enabled).on(:change) do |sender|
        style = sender.isOn ? :section_button_enabled : :section_button_disabled
        buttons = rmq(sender).parent.find(UIButton).apply_style(style)
      end

      q.append(UIButton, :start_spinner).on(:tap) do |sender|
        q.animations.start_spinner
      end

      q.append(UIButton, :stop_spinner).on(:tap) do |sender|
        q.animations.stop_spinner
      end
    end

  end

end
