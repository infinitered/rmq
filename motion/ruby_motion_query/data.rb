module RubyMotionQuery
  class ViewData
    attr_accessor :events, :style_name

    def initialize(view)
      @view = RubyMotionQuery::RMQ.weak_ref(view)
    end

    # @return [Hash] Array of tag names assigned to to this view
    def tags
      @_tags ||= {}
    end

    # @return [Array] Array of tag names assigned to to this view
    def tag_names
      tags.keys
    end

    # *Do not* use this, use {RMQ#tag} instead: 
    # @example
    #   rmq(my_view).tag(:foo)
    def tag(*tag_or_tags)
      tag_or_tags.flatten!
      tag_or_tags = tag_or_tags.first if tag_or_tags.length == 1

      if tag_or_tags.is_a?(Array)
        tag_or_tags.each do |tag_name|
          tags[tag_name] = 1
        end
      elsif tag_or_tags.is_a?(Hash)
        tag_or_tags.each do |tag_name, tag_value|
          tags[tag_name] = tag_value 
        end
      elsif tag_or_tags.is_a?(Symbol)
        tags[tag_or_tags] = 1
      end
    end

    # Check if this view contains a specific tag
    #
    # @param tag_name name of tag to check
    # @return [Boolean] true if this view has the tag provided
    def has_tag?(tag_name = nil)
      if tag_name
        tags.include?(tag_name)
      else
        RMQ.is_blank?(@_tags)
      end
    end

    def view_controller=(value)
      @view_controller = RubyMotionQuery::RMQ.weak_ref(value)
    end

    def view_controller
      @view_controller
    end

    def frame
      @frame ||= Frame.new(@view)
    end
  end

  class ControllerData
    attr_accessor :stylesheet, :cached_rmq
  end
end
