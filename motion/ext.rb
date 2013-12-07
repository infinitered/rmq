class Object
  def rmq(*selectors)
    if window = RubyMotionQuery::RMQ.app.window
      RubyMotionQuery::RMQ.app.current_view_controller.rmq(selectors)
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

  # I intend for this to be protected
  # Do not call rmq from outside a view. Because of some weirdness with table cells
  # and event blocks this has to be public (later I want to figure out why exactly).
  #
  # Technically my_view.rmq is the same as rmq(my_view), so it may seem enticing to use
  # but the really nice thing about rmq is its consistent API, and doing this
  # for one view: my_view.rmq and this for two views: rmq(my_view, my_other_view) sucks
  def rmq(*selectors)
    RubyMotionQuery::RMQ.create_with_selectors(selectors, self).tap do |o|
      if vc = self.rmq_data.view_controller
        o.view_controller = vc
      end
    end
  end
end

class UIViewController
  def rmq(*selectors)
    crmq = (rmq_data.cached_rmq ||= RubyMotionQuery::RMQ.create_with_selectors([], self))

    if selectors.length == 0
      crmq
    else
      RubyMotionQuery::RMQ.create_with_selectors(selectors, self, crmq)
    end
  end

  def rmq_data
    @_rmq_data ||= RubyMotionQuery::ControllerData.new
  end
end
