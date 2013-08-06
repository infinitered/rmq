module RubyMotionQuery
  class RMQ

    # @return [RMQ]
    def tag(*tag_or_tags)
      selected.each do |view|
        view.rmq_data.tag(tag_or_tags)
      end
      self
    end

    # See /lib/data.rb for the rest of the tag stuff

  end
end
