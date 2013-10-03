# See traversing.rb and selectors.rb for finding and traversing subviews
module RubyMotionQuery
  class RMQ

    # @return [RMQ]
    def remove
      selected.each { |view| view.removeFromSuperview }
      self
    end

    # @return [RMQ]
    def add_subview(view_or_constant, opts={})
      subviews_added = []
      style = opts[:style]

      if RMQ.debugging?
        opts[:caller] ||= caller.first
      end

      selected.each do |selected_view|
        created = false

        if view_or_constant.is_a?(UIView)
          new_view = view_or_constant
        else
          created = true
          new_view = create_view(view_or_constant, opts)
        end

        subviews_added << new_view

        unless opts[:do_not_add]
          if at_index = opts[:at_index]
            selected_view.insertSubview(new_view, atIndex: at_index)
          elsif below_view = opts[:below_view]
            selected_view.insertSubview(new_view, belowSubview: below_view)
          else
            selected_view.addSubview(new_view)
          end
        end

        if self.stylesheet
          apply_style_to_view(new_view, style) if style
        end

        new_view.rmq_data.source = opts[:caller]
        new_view.rmq_did_create(self.wrap(new_view)) if created
      end

      RMQ.create_with_array_and_selectors(subviews_added, selectors, @context, self)
    end
    alias :insert :add_subview

    # @return [RMQ]
    def append(view_or_constant, style=nil, opts = {})
      opts[:style] = style
      if RMQ.debugging?
        opts[:caller] = caller.first
      end
      add_subview(view_or_constant, opts)
    end

    # @return [RMQ]
    def unshift(view_or_constant, style=nil, opts = {})
      opts[:at_index] = 0
      opts[:style] = style
      if RMQ.debugging?
        opts[:caller] = caller.first
      end
      add_subview view_or_constant, opts
    end
    alias :prepend :unshift

    # Creates a view then returns an rmq with that view in it. It does not add that 
    # view to the view tree. This is useful for stuff like creating table cells. You
    # can use the rmq_did_create method, just like you do when you append a subview
    #
    # @return [RMQ] wrapping the view that was just create
    #
    # @example
    #   def tableView(table_view, cellForRowAtIndexPath: index_path)
    #     cell = tableView.dequeueReusableCellWithIdentifier(CELL_IDENTIFIER) || begin 
    #       rmq.create(StoreCell, :store_cell, reuse_identifier: CELL_IDENTIFIER)
    #     end
    #   end
    #
    #   class StoreCell < UITableViewCell 
    #     def rmq_did_create(self_in_rmq)
    #       self_in_rmq.append(UILabel, :title_label)
    #     end
    #   end
    #
    def create(view_or_constant, style = nil, opts = {})
      # TODO, refactor so that add_subview uses create, not backwards like it is now
      opts[:do_not_add] = true
      opts[:style] = style
      add_subview view_or_constant, opts
    end

    protected

    def create_view(klass, opts)
      if klass == UIButton
        klass.buttonWithType(UIButtonTypeCustom).tap do |o|
          o.hidden = false
          o.opaque = true
        end
      elsif reuse_identifier = opts[:reuse_identifier]
        klass.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: reuse_identifier).tap do |o|
          o.hidden = false
          o.opaque = true
        end
      else
        klass.alloc.initWithFrame(CGRectZero).tap do |o|
          o.hidden = false
          o.opaque = true
        end
      end
    end

  end
end
