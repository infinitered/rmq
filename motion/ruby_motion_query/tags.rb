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

    def untag(*tag_or_tags)
      puts "this it untag"
    end

    # @return [RMQ]
    def clear_tags
      selected.each do |view|
        view.rmq_data.tags.clear
      end
      self
    end

    # Check if any of the selected has a given tag
    # @example
    #   rmq(my_view).has_tag?(:your_tag) #false
    #   rmq(my_view).tag(:your_tag)
    #   rmq(my_view).has_tag?(:your_tag) #true
    #
    # @return [Boolean] true if any selection views have tag provided
    def has_tag? tag
      selected.each do |view|
        return true if view.rmq_data.has_tag?(tag)
      end
      false # tag doesn't exist if we got here
    end

    # See /motion/data.rb for the rest of the tag stuff

  end
end
