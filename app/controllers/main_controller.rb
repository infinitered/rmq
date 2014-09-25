class MainController < UIViewController

  def viewDidLoad
    super

    rmq.stylesheet = MainStylesheet
    rmq(self.view).apply_style :root_view

    init_nav

    rmq.append UIImageView, :logo

    init_buttons
    init_popup_section
    init_validation_section

    rmq.append Section
  end

  def init_nav
    self.title = 'Title Here'

    self.navigationItem.tap do |nav|
      nav.leftBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemAction,
                                                                           target: self, action: :nav_left_button)
      nav.rightBarButtonItem = UIBarButtonItem.alloc.initWithBarButtonSystemItem(UIBarButtonSystemItemRefresh,
                                                                           target: self, action: :nav_right_button)
    end
  end

  def nav_left_button
    puts 'Left button'
  end

  def nav_right_button
    puts 'Right button'
  end

  # Remove if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  # Remove if you are only supporting portrait
  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    rmq.all.reapply_styles
  end
  # You don't have to reapply styles to all UIViews, if you want to optimize,
  # another way to do it is tag the views you need to restyle in your stylesheet,
  # then only reapply the tagged views, like so:
  #
  # def logo(st)
  #    st.frame = {t: 10, w: 200, h: 96}
  #    st.centered = :horizontal
  #    st.image = image.resource('logo')
  #    st.tag(:reapply_style)
  #  end
  #
  # Then here in willAnimateRotationToInterfaceOrientation
  #  rmq(:reapply_style).reapply_styles

  def init_buttons
    rmq.append(UIButton, :make_labels_blink_button).on(:tap) do |sender|
      rmq(UILabel).animations.blink
    end

    rmq.append(UIButton.buttonWithType(UIButtonTypeRoundedRect), :make_buttons_throb_button).on(:tap) do |sender|
      rmq(UIButton).not(sender).animations.throb
    end

    rmq.append(UIButton, :animate_move_button).on(:tap) do |sender|
      rmq(sender).animate( duration: 0.5, animations: -> (rmq) {
        # You really should create a new style in the stylesheet,
        # but you can do it inline too, like so
        rmq.style do |sv|
          sv.top = rand(rmq.device.height)
          sv.scale = 10.0
        end
      },
      completion: -> (did_finish, rmq) {
        rmq.animate( duration: 0.2, animations: -> (rmq) {
            rmq.style do |sv|
              sv.scale = 1.0
              sv.top = 230
            end
          })
      })
    end

    rmq.append(UIButton, :collection_button).on(:touch_up) do |sender|
      controller = CollectionController.new
      rmq.view_controller.navigationController.pushViewController(controller, animated: true)
    end

    rmq.append(UIButton, :table_button).on(:touch_up) do |sender|
      controller = TableController.new
      rmq.view_controller.navigationController.pushViewController(controller, animated: true)
    end

    rmq.append(UIButton, :present_button).on(:touch_up) do |sender|
      rmq.view_controller.presentModalViewController(PresentedController.new, animated:true)
    end
  end

  def init_popup_section

    rmq.append(UIView, :popup_section).tap do |q|

      @title_label = q.append!(UILabel, :title_label)
      q.append(UIButton, :open_popup).on(:touch_down) do |sender|

        rmq(sender).apply_style(:open_popup_disabled)
        rmq.animations.start_spinner

        rmq.append(UIView, :overlay).animations.fade_in.on(:tap) do |sender|
          rmq.find(:popup_text_label, :popup_wrapper, sender).hide.remove
        end

      end.on(:touch_up) do |sender|

        rmq.append(UILabel, :popup_wrapper).tap do |o|
          o.animations.fade_in
          o.append(UILabel, :popup_text_label)
        end

        rmq(sender).apply_style(:open_popup)
        rmq.animations.stop_spinner

      end
    end

  end

  def init_validation_section

    # let's lay this out using the grid!
    rmq.append(UIView, :validation_section).tap do |q|
      q.append(UILabel, :validation_title)
      @digits_only = q.append(UITextField, :only_digits).validates(:digits).on(:change) do |sender|
        rmq(sender).valid?
      end.
      on(:valid) do |sender|
        rmq(sender).apply_style :valid
      end.
      on(:invalid) do |sender|
        rmq(sender).apply_style :invalid
      end.get

      @email_only = q.append(UITextField, :only_email).validates(:email).on(:change) do |sender|
        rmq(sender).valid?
      end.
      on(:valid) do |sender|
        rmq(sender).apply_style :valid
      end.
      on(:invalid) do |sender|
        rmq(sender).apply_style :invalid
      end.get

    end

    #set up keyboard dismissing
    @digits_only.delegate = self
    @digits_only.returnKeyType = UIReturnKeyDone
    @email_only.delegate = self
    @email_only.returnKeyType = UIReturnKeyDone

  end

  def textFieldShouldReturn(sender)
    sender.resignFirstResponder
    true
  end
end
