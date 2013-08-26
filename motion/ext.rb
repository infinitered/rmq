class UIView
  def rmq_data
    @_rmq_data ||= RubyMotionQuery::ViewData.new
  end

  # Override in your view if you want to setup subviews after your view has 
  # been created by rmq, usually through an #append or #create
  #
  # @param [RMQ] rmq that created your view
  #
  # In your view
  # @example
  #   def rmq_did_create(self_in_rmq)
  #     self_in_rmq.tap do |q|
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
  def rmq_did_create(self_in_rmq)
  end

  # I intend for this to be protected
  # Do not call rmq from outside a view. Because of some weirdness with table cells
  # and event blocks this has to be public (later I want to figure out why exactly).
  #
  # Technically my_view.rmq is the same as rmq(my_view), so it may seem enticing to use
  # but the really nice thing about rmq is its consistent API, and doing this
  # for one view: my_view.rmq and this for two views: rmq(my_view, my_other_view) sucks
  def rmq(*selectors)
    RubyMotionQuery::RMQ.create_with_selectors(selectors, self)
  end
end

class UIViewController
  def rmq(*selectors)
    if RubyMotionQuery::RMQ.cache_controller_rmqs && selectors.length == 0
      rmq_data.rmq ||= RubyMotionQuery::RMQ.create_with_selectors(selectors, self)
    else
      RubyMotionQuery::RMQ.create_with_selectors(selectors, self, rmq_data.rmq)
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
