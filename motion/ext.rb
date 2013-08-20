class UIView
  def rmq_data
    @_rmq_data ||= RubyMotionQuery::ViewData.new
  end

  # Override in your view if you want to setup subviews after your view has 
  # been created by rmq, usually through an #append
  #
  # In your view
  # @example
  #   def rmq_did_create
  #     rmq(self).tap do |q|
  #       q.append(UILabel, :section_title)
  #       q.append(UIButton, :buy_button).on(:tap) do |sender|
  #         # do  something
  #       end
  #     end
  #   end
  #
  # In your controller
  # @example
  #   rmq.append(YourView, :your_style)
  #
  # In this example an instance of YourView is created, :your_style is applied
  # then rmq_did_create is called on the instance that was just created. In that
  # order.
  def rmq_did_create
  end

  protected

  def rmq(*selectors)
    RubyMotionQuery::RMQ.create_with_selectors(selectors, self)
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
