class Object
  def rmq(*working_selectors)
    if (app = RubyMotionQuery::RMQ.app) && (window = app.window) && (cvc = app.current_view_controller)
      cvc.rmq(working_selectors)
    else
      RubyMotionQuery::RMQ.create_with_array_and_selectors([], working_selectors, self)
    end
  end
end

class UIView
  def rmq_data
    @_rmq_data ||= RubyMotionQuery::ViewData.new
  end

  # @deprecated No longer needed, use rmq_build
  def rmq_did_create(self_in_rmq)
  end
  def rmq_created
  end

  # Override this to build your view and view's subviews
  def rmq_build
  end

  def rmq_appended
  end

  # Technically my_view.rmq is the same as rmq(my_view), so it may seem enticing to use
  # but the really nice thing about rmq is its consistent API, and doing this
  # for one view: my_view.rmq and this for two views: rmq(my_view, my_other_view) sucks
  def rmq(*working_selectors)
    RubyMotionQuery::RMQ.create_with_selectors(working_selectors, self).tap do |o|
      if vc = self.rmq_data.view_controller
        o.weak_view_controller = vc
      end
    end
  end
end

class UIViewController
  def rmq(*working_selectors)
    crmq = (rmq_data.cached_rmq ||= RubyMotionQuery::RMQ.create_with_selectors([], self))

    if working_selectors.length == 0
      crmq
    else
      RubyMotionQuery::RMQ.create_with_selectors(working_selectors, self, crmq)
    end
  end

  def rmq_data
    @_rmq_data ||= RubyMotionQuery::ControllerData.new
  end
end
