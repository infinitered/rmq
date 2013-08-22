module RubyMotionQuery
  class RMQ

    # Add tags
    # @example
    #    rmq(my_view).tag(:your_tag)
    #    rmq(my_view).clear_tags.tag(:your_new_tag)
    #    rmq(my_view).find(UILabel).tag(:selected, :customer)
    #
    # You can optionally store a value in the tag, which can be super useful in some rare situations
    # @example
    #    rmq(my_view).tag(your_tag: 22)
    #    rmq(my_view).tag(your_tag: 22, your_other_tag: 'Hello world')
    #
    # @return [RMQ]
    def tag(*tag_or_tags)
      selected.each do |view|
        view.rmq_data.tag(tag_or_tags)
      end
      self
    end

    # @return [RMQ]
    def clear_tags
      selected.each do |view|
        view.rmq_data.tags.clear
      end
      self
    end

    # See /motion/data.rb for the rest of the tag stuff

  end
end
