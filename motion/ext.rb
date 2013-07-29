class UIView
  def rmq_data
    @_rmq_data ||= RubyMotionQuery::ViewData.new
  end

  protected

  def rmq(*selectors)
    RubyMotionQuery::RMQ.create_with_selectors(selectors, RubyMotionQuery::RMQ.controller_for_view(self))
  end
end

class UIViewController
  def rmq(*selectors)
    if RubyMotionQuery::RMQ.cache_controller_rmqs && selectors.length == 0
      rmq_data.rmq ||= RubyMotionQuery::RMQ.create_with_selectors(selectors, self)
    else
      RubyMotionQuery::RMQ.create_with_selectors(selectors, self)
    end
  end

  def rmq_data
    @_rmq_data ||= RubyMotionQuery::ControllerData.new
  end
end

# Used in console, so that you can just call rmq with an view or controller as self
class TopLevel
  def rmq(*selectors)
    if window = RubyMotionQuery::RMQ.app.window
      RubyMotionQuery::RMQ.create_with_selectors(selectors, window.subviews.first)
    end
  end
end
