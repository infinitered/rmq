module RubyMotionQuery
  class RMQ

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
