module RubyMotionQuery
  class ViewData
    attr_accessor :events, :style_name

    def tags
      @_tags ||= {}
    end

    def tag_names
      tags.keys
    end

    def tag(*tag_or_tags)
      tag_or_tags.flatten!
      tag_or_tags.each do |tag_name|
        tags[tag_name] = 1
      end
    end

    def has_tag?(tag_name = nil)
      if tag_name
        tags.include?(tag_name)
      else
        RMQ.is_blank?(@_tags)
      end
    end
  end

  class ControllerData
    attr_accessor :stylesheet, :rmq
  end
end
