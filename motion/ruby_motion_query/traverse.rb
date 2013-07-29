module RubyMotionQuery 
  class RMQ

    # Most everthing uses filter to do its work
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

    def all
      self.view_controller.rmq.find
    end

    def and(*working_selectors)
      return self unless working_selectors
      normalize_selectors(working_selectors)

      self.select do |view|
        match(view, working_selectors)
      end
    end

    def not(*working_selectors)
      return self unless working_selectors
      normalize_selectors(working_selectors)

      self.reject do |view|
        match(view, working_selectors)
      end
    end

    # Return any selected that has a child that matches the selectors
    #def has
    #end

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
    
    def end
      @parent_rmq || self
    end

    def parent
      closest(UIView)
    end
    alias :superview :parent

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

    def siblings(*working_selectors)
      normalize_selectors(working_selectors)

      self.parent.children.not(selected)
    end

    # TODO
    #def next(*working_selectors)
    #end
    #def prev(*working_selectors)
    #end
    #

    def closest(*working_selectors)
      normalize_selectors(working_selectors)

      filter do |view|
        closest_view(view, working_selectors)
      end
    end

    def view_controller
      @_view_controller ||= begin
        if @context.is_a?(UIViewController)
          @context
        else
          RMQ.controller_for_view(@context)
        end
      end
    end

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
