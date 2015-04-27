class PresentedController < UIViewController

  def viewDidLoad
    super

    rmq.stylesheet = PresentedControllerStylesheet
    rmq(self.view).apply_style :root_view

    rmq.append(UIView, :wrapper_view).append(UILabel, :inner_view)

    rmq.append(UIButton, :close_controller).on(:touch) do
      self.dismissViewControllerAnimated true, completion: nil
    end
  end

  # Remove these if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end
  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    # Called before rotation
    rmq.all.reapply_styles
  end
  def viewWillLayoutSubviews
    # Called anytime the frame changes, including rotation, and when the in-call status bar shows or hides
    #
    # If you need to reapply styles during rotation, do it here instead
    # of willAnimateRotationToInterfaceOrientation, however make sure your styles only apply the layout when
    # called multiple times
  end
  def didRotateFromInterfaceOrientation(from_interface_orientation)
    # Called after rotation
  end

  def dealloc
    puts "Deallocing: #{self.class.name} - #{self.object_id}"
    super
  end
end
