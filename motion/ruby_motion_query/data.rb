module RubyMotionQuery
  class ViewData
    attr_accessor :events, :built

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

    # *Do not* use this, use {RMQ#untag} instead:
    # @example
    #   rmq(my_view).untag(:foo, :bar)
    # Do nothing if no tag supplied or tag not present
    def untag(*tag_or_tags)
      tag_or_tags.flatten.each do |tag_name|
        tags.delete tag_name
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

    def style_name
      styles.first
    end

    # Sets first style name, this is only here for backwards compatibility and as
    # a convenience method
    def style_name=(value)
      styles[0] = value
    end

    # view.rmq_data.styles = [:something]
    # Convenience method for setting the entire styles variable
    def styles=(s)
      @_styles = Array(s)
    end

    #view.rmq_data.styles
    def styles
      @_styles ||= []
    end

    #view.rmq_data.has_style?(:style_name_here)
    def has_style?(name = nil)
      if name
        styles.include?(name)
      else
        RMQ.is_blank?(@_styles)
      end
    end

    def validation_errors; @_validation_errors ||= {}; end
    def validation_errors=(value); @_validation_errors = value; end
    def validations; @_validations ||= []; end
    def validations=(value); @_validations = value; end

    def view_controller=(value)
      #RubyMotionQuery::RMQ.debug.assert(value.is_a?(UIViewController), 'Invalid controller in ViewData', { controller: value })

      @_view_controller = RubyMotionQuery::RMQ.weak_ref(value)
    end

    def view_controller
      @_view_controller
    end
  end

  class ControllerData
    attr_accessor :stylesheet, :cached_rmq
  end
end
