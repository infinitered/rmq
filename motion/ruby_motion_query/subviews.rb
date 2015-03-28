# See traversing.rb and selectors.rb for finding and traversing subviews
module RubyMotionQuery
  class RMQ

    # Removes the selected views from their parent's (superview) subview array
    #
    # @example
    #   rmq(a_view, another_view).remove
    #
    # @return [RMQ]
    def remove
      selected.each { |view| view.removeFromSuperview }
      self
    end

    # This is used by build, create, and append. You really shouldn't use it
    # directly. Although it's totally fine if you do
    #
    # @return [RMQ]
    def add_subview(view_or_constant, opts={})
      subviews_added = []

      selected.each do |selected_view|
        created = false
        appended = false
        built = false

        if view_or_constant.is_a?(UIView)
          new_view = view_or_constant
        else
          created = true
          new_view = create_view(view_or_constant, opts)
        end

        rmq_data = new_view.rmq_data

        unless rmq_data.built
          rmq_data.built = true # build only once
          built = true
        end

        rmq_data.view_controller = self.weak_view_controller

        subviews_added << new_view

        unless opts[:do_not_add]
          if at_index = opts[:at_index]
            selected_view.insertSubview(new_view, atIndex: at_index)
          elsif below_view = opts[:below_view]
            selected_view.insertSubview(new_view, belowSubview: below_view)
          else
            selected_view.addSubview(new_view)
          end

          appended = true
        end

        if created
          new_view.rmq_created
        end
        new_view.rmq_build if built
        new_view.rmq_appended if appended

        if self.stylesheet
          apply_style_to_view(new_view, opts[:style]) if opts[:style]
        end
      end

      view = RMQ.create_with_array_and_selectors(subviews_added, selectors, @context, self)
      opts[:block].call view if opts[:block]
      opts[:raw_block].call view.get if opts[:raw_block]
      view
    end
    alias :insert :add_subview

    # Performs a create, then appends view to the end of the subview array of the
    # views you have selected (or the rootview if you have nothing selected).
    #
    # When you build, create, or append a view, the method rmq_build is called
    # inside the view. If you are creating a your own subclass of a UIView, then
    # that is a good place to do your initialization. Your view is created, then
    # appended, then rmq_build is called, then the style is applied (if it exists)
    #
    # @example
    #   # Creating a new view instance then append it. Passing in the class
    #   # to create
    #   rmq.append(UIButton, :my_button_style)
    #   @title = rmq.append(ULabel, :title).get
    #
    #   # You can also pass in an existing view
    #   my_view = UIView.alloc.initWithFrame([[0,0],[10,10]])
    #   rmq.append(my_view, :my_style)
    #
    #   # Stylename is optional
    #   rmq.append(UIImageView)
    #
    # @return [RMQ]
    def append(view_or_constant, style=nil, opts = {}, &block)
      opts[:style] = style
      opts[:block] = block if block
      add_subview(view_or_constant, opts)
    end

    # Same as append, but instantly returns the view, without having to use .get
    #
    # @example
    #   @my_button = rmq.append! UIButton
    #   @my_label = rmq.append!(UILabel, :my_label)
    def append!(view_or_constant, style=nil, opts = {}, &block)
      opts[:raw_block] = block if block
      append(view_or_constant, style, opts).get
    end

    # Same as append, but will look for a view with the same name and reapply styles
    # to it if it finds one. If it doesn't, it'll append as normal.
    #
    # @example
    #   @my_button = rmq.find_or_append(UIButton, :my_button)
    #   @my_button = rmq.find_or_append(UIButton, :my_button) # Only one created
    def find_or_append(view_or_constant, style=nil, opts = {}, &block)
      if style && (q = self.find(style)) && q.length > 0
        view_or_constant = q.get
      end

      append(view_or_constant, style, opts, &block)
    end

    # Same as append!, but will look for a view with the same name and reapply styles
    # to it if it finds one. If it doesn't, it'll append! as normal.
    #
    # @example
    #   @my_button = rmq.find_or_append!(UIButton, :my_button)
    #   @my_button = rmq.find_or_append!(UIButton, :my_button) # Only one created
    def find_or_append!(view_or_constant, style=nil, opts = {}, &block)
      find_or_append(view_or_constant, style, opts, &block).get
    end

    # Just like append, but inserts the view at index 0 of the subview array
    #
    # @return [RMQ]
    def unshift(view_or_constant, style=nil, opts = {}, &block)
      opts[:at_index] = 0
      opts[:style] = style
      opts[:block] = block if block
      add_subview view_or_constant, opts
    end
    alias :prepend :unshift

    # Same as prepend, but instantly returns the view, without having to use .get
    #
    # @example
    #   @my_button = rmq.prepend! UIButton
    #   @my_label = rmq.prepend!(UILabel, :my_label)
    def unshift!(view_or_constant, style=nil, opts = {}, &block)
      opts[:raw_block] = block if block
      unshift(view_or_constant, style, opts).get
    end
    alias :prepend! :unshift!

    # Creates a view then returns an rmq with that view in it. It does not add that
    # view to the view tree (append does this). This is useful for stuff like creating
    # table cells. You can use the rmq_did_create method, just like you do when you
    # append a subview
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
    def create(view_or_constant, style = nil, opts = {}, &block)
      # TODO, refactor so that add_subview uses create, not backwards like it is now
      opts[:do_not_add] = true
      opts[:style] = style
      opts[:block] = block if block
      add_subview view_or_constant, opts
    end

    # Same as create, but instantly returns the view, without having to use .get
    #
    # @example
    #   @my_button = rmq.create! UIButton
    def create!(view_or_constant, style=nil, opts = {}, &block)
      opts[:raw_block] = block if block
      create(view_or_constant, style, opts).get
    end

    # Build a view, similar to create and append, but only inits an existing view. Usefull
    # in collectionview cells for example
    #
    # @example
    # # In your collectionview
    # rmq.build(cell) unless cell.reused
    #
    # # Then in your cell
    #
    # def rmq_build
    #   rmq.append(UIView, :foo)
    # end
    def build(view, style = nil, opts = {}, &block)
      opts[:do_not_add] = true
      opts[:style] = style
      opts[:block] = block if block
      add_subview view, opts
    end

    # Same as build, but instantly returns the view, without having to use .get
    #
    # @example
    #   @my_cell = rmq.build! cell
    def build!(view, style = nil, opts = {}, &block)
      opts[:raw_block] = block if block
      build(view, style, opts).get
    end


    protected

    def create_view(klass, opts)
      if (klass == UIButton) || klass < UIButton
        klass.buttonWithType(UIButtonTypeCustom).tap do |o|
          o.hidden = false
          #o.setTitleColor(rmq.color.black, forState: UIControlStateNormal)
          #o.setTitle('Ok', forState: UIControlStateNormal)
          o.opaque = true
        end
      elsif (klass == UIActivityIndicatorView) || klass < UIActivityIndicatorView
        klass.alloc.initWithActivityIndicatorStyle(UIActivityIndicatorViewStyleWhite).tap do |o|
          o.hidden = false
          o.opaque = true
        end
      elsif reuse_identifier = opts[:reuse_identifier]
        style = opts[:cell_style] || UITableViewCellStyleDefault
        klass.alloc.initWithStyle(style, reuseIdentifier: reuse_identifier).tap do |o|
          o.hidden = false
          o.opaque = true
        end
      elsif (klass == UITableView) || klass < UITableView
        style = opts[:table_style] || UITableViewStylePlain
        klass.alloc.initWithFrame(CGRectZero, style: style).tap do |o|
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
