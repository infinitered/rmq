module RubyMotionQuery 
  class RMQ

    # Most everything uses filter to do its work. This is mostly used internally
    # but you can use it too. Just pass a block that returns views, it will be
    # called for every view that is *selected*
    #
    # @param return_array returns array not rmq: return_array: true 
    # @param uniq removes duplicate views: uniq: true 
    # @param limit limits the number of views *per selected view*: limit: true 
    #
    # @return [RMQ]
    def filter(opts = {}, &block)
      out = []
      limit = opts[:limit]

      selected.each do |view|
        results = yield(view)
        unless RMQ.is_blank?(results)
          out << results 
          break if limit && (out.length >= limit)
        end
      end
      out.flatten!
      out.uniq! if opts[:uniq]

      if opts[:return_array]
        out
      else
        rmq = RMQ.create_with_array_and_selectors(out, selectors, @context)
        rmq.parent_rmq = self
        rmq
      end
    end

    # @return [RMQ] All selected views
    #
    # @example
    #   rmq.all.log
    def all
      self.view_controller.rmq.find
    end

    # @return [RMQ] A new rmq instance reducing selected views to those that match selectors provided
    #
    # @param selectors your selector
    #
    # @example
    #   rmq(UIImage).and(:some_tag).attr(image: nil)
    def and(*working_selectors)
      return self unless working_selectors
      normalize_selectors(working_selectors)

      self.select do |view|
        match(view, working_selectors)
      end
    end

    # @return [RMQ] A new rmq instance removing selected views that match selectors provided
    #
    # @param selectors
    #
    # @example
    #   # Entire family of labels from siblings on down
    #   rmq(my_label).parent.find(UILabel).not(my_label).move(left: 10)
    def not(*working_selectors)
      return self unless working_selectors
      normalize_selectors(working_selectors)

      self.reject do |view|
        match(view, working_selectors)
      end
    end

    # @return [RMQ] A new rmq instance adding the context to the selected views
    #
    # @example
    #   rmq(my_view).children.and_self
    def and_self
      if @parent_rmq
        out = @parent_rmq.selected.dup
        out << selected
        out.flatten!
        RMQ.create_with_array_and_selectors(out, selectors, @context)
      else
        self
      end
    end
    alias :add_self :and_self
    
    # @return [RMQ] The parent rmq instance 
    #
    # @example
    #   rmq(test_view).find(UIImageView).tag(:foo).end.find(UILabel).tag(:bar)
    def end
      @parent_rmq || self
    end

    # @return [RMQ] rmq instance selecting the parent of the selected view(s)
    #
    # @example
    #   rmq(my_view).parent.find(:delete_button).toggle_enabled
    def parent
      closest(UIView)
    end
    alias :superview :parent

    # @return [RMQ] Instance selecting the parents, grandparents, etc, all the way up the tree 
    # of the selected view(s)
    #
    # @param selectors
    #
    # @example
    #   rmq(my_view).parents.log
    def parents(*working_selectors)
      normalize_selectors(working_selectors)

      filter(uniq: true) do |view|
        superviews = all_superviews_for(view)

        if RMQ.is_blank?(working_selectors)
          superviews
        else
          superviews.inject([]) do |subview, out|
            out << subview if match(subview, working_selectors)
            out
          end
        end
      end
    end
    alias :superviews :parents

    # Get the descendants of each view in the current set of selected views, filtered by a selector(s)
    #
    # @return [RMQ] Instance selecting the children, grandchildren, etc of the selected view(s)
    #
    # @param selectors
    #
    # @example
    #   rmq(my_view).find(UIButton).show
    def find(*working_selectors)
      normalize_selectors(working_selectors)

      filter(uniq: true) do |view|
        subviews = all_subviews_for(view)

        if RMQ.is_blank?(working_selectors)
          subviews
        else
          subviews.inject([]) do |out, subview|
            out << subview if match(subview, working_selectors)
            out
          end
        end
      end
    end

    # @return [RMQ] Instance selecting the children of the selected view(s)
    #
    # @param selectors
    #
    # @example
    #   rmq(my_view).children.show
    def children(*working_selectors)
      normalize_selectors(working_selectors)

      filter do |view|
        subviews = view.subviews

        if RMQ.is_blank?(working_selectors)
          subviews
        else
          subviews.inject([]) do |out, subview|
            out << subview if match(subview, working_selectors)
            out
          end
        end
      end
    end
    alias :subviews :children


    # @return [RMQ] Siblings of the selected view(s)
    #
    # @param selectors
    #
    # @example
    #   rmq(my_view).siblings.send(:poke)
    def siblings(*working_selectors)
      normalize_selectors(working_selectors)

      self.parent.children.not(selected)
    end


    # @return [RMQ] Sibling above to the selected view(s)
    #
    # @param selectors
    #
    # @example
    #   rmq(my_view).next(UITextField).focus
    def next(*working_selectors)
      normalize_selectors(working_selectors)

      filter do |view|
        subs = view.superview.subviews
        location = subs.index(view)
        if location < subs.length - 1
          subs[location + 1]
        end
      end
    end

    # @return [RMQ] Sibling below to the selected view(s)
    #
    # @param selectors
    #
    # @example
    #   rmq(my_view).prev(UITextField).focus
    def prev(*working_selectors)
      normalize_selectors(working_selectors)

      filter do |view|
        subs = view.superview.subviews
        location = subs.index(view)
        if location > 0
          subs[location - 1]
        end
      end
    end

    # For each selected view, get the first view that matches the selector(s) by testing the view's parent and 
    # traversing up through its ancestors in the tree
    #
    # @return [RMQ] Instance selecting the first parent or grandparent or ancestor up the tree of the selected view(s)
    #
    # @param selectors
    #
    # @example
    #   rmq.closest(UIScrollView).get.setContentOffset([0,0])
    def closest(*working_selectors)
      normalize_selectors(working_selectors)

      filter do |view|
        closest_view(view, working_selectors)
      end
    end

    # @return [UIViewController] Controller of this rmq instance
    #
    # @example
    #   rmq.view_controller
    def view_controller
      @_view_controller ||= begin
        if @context.is_a?(UIViewController)
          @context
        else
          RMQ.controller_for_view(@context)
        end
      end
    end

    # @return [UIView] Root view of this rmq instance's controller
    #
    # @example
    #   rmq.root_view
    def root_view
      vc = self.view_controller
      if RMQ.is_blank?(vc)
        self.context_or_context_view
      else
        self.view_controller.view
      end
    end

    protected 

    def closest_view(view, working_selectors)
      if nr = view.nextResponder
        if match(nr, working_selectors)
          nr
        else
          closest_view(nr,working_selectors)
        end
      else
        nil
      end     
    end

  end
end
