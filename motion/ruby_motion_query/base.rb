module RubyMotionQuery

  # The main class for RubyMotionQuery
  #
  # What's an rmq instance?
  # - an rmq instance is an array-like object containing UIViews
  # - rmq() never returns nil. If nothing is selected, it's an empty [ ] array-like
  #   object   
  # - an rmq object always (almost always) returns either itself or a new
  #   rmq object. This is  how chaining works. You do not need to worry if
  #   an rmq is blank or not, everything  always works without throwing a
  #   nil exception
  # - jQuery uses the DOM, what is rmq using for the "DOM"? It uses the
  #   controller it was  called in. The "DOM" is the controller's subview
  #   tree. If you call rmq inside a view, it will  attach to the
  #   controller that the view is currently in or to the current screen's
  #   controller
  class RMQ
    attr_accessor :context, :parent_rmq

    def initialize
      @selected_dirty = true
    end

    # Do not use
    def selected=(value)
      @_selected = value
      @selected_dirty = false
    end

    # The UIViews currently selected
    # Use {#get} instead to get the actual UIView objects
    def selected
      if @selected_dirty
        @_selected = []

        if RMQ.is_blank?(self.selectors)
          @_selected << context_or_context_view
        else
          working_selectors = self.selectors.dup
          extract_views_from_selectors(@_selected, working_selectors)

          unless RMQ.is_blank?(working_selectors)
            subviews = all_subviews_for(root_view)
            subviews.each do |subview|
              @_selected  << subview if match(subview, working_selectors)
            end
          end

          @_selected.uniq!
        end

        @selected_dirty = false
      else
        @_selected ||= []
      end

      @_selected
    end

    # The view(s) this rmq was derived from
    def origin_views
      if @parent_rmq
        @parent_rmq.selected
      else
        [self.view_controller.view]
      end
    end

    # Returns a view or array of views. 
    # Normally used to get the only view in selected.
    #
    # @example
    #   # returns my_view
    #   rmq(my_view).get
    #
    #   # returns an array
    #   rmq(UILabel).get
    #
    #   rmq(foo).parent.get.some_method_on_parent
    def get
      sel = self.selected
      if sel.length == 1
        sel.first
      else
        sel
      end
    end

    # Is this rmq a root instance? Which means it only has 1 selected view, and that view
    # is the view you called rmq in. Which is a tad confusing, but if you call *just* rmq inside a 
    # view, then only that view will be *selected* and this rmq will be *root*. If you call rmq
    # inside a controller, only controller.view will be selected and the rma instance will be a root.
    def root?
      (selected.length == 1) && (selected.first == @context)
    end

    # The context is where rmq was created (not the selectors). 
    # Normally you are inside a controller or a UIView when you execute the rmq method. 
    # @return the controller's view or the view you are in when calling rmq
    def context_or_context_view
      if @context.is_a?(UIViewController)
        @context.view
      else
        @context
      end
    end

    # Changed inspect to be useful
    # @example
    #   (main)> rmq.all
    #   => RMQ 172658240. 26 selected. selectors: []. .log for more info
    def inspect
      out = "RMQ #{self.object_id}. #{self.count} selected. selectors: #{self.selectors.to_s}. .log for more info"
      out << "\n[#{selected.first}]" if self.count == 1
      out
    end

    # Super useful in the console. log outputs to the console a table of the selected views
    # @param :wide outputs wide format (really wide, but awesome: rmq.all.log :wide)
    # @example
    #    (main)> rmq(UIImageView).log
    #
    #    object_id   | class                 | style_name              | frame                           |
    #    sv id       | superview             | subviews count          | tags                            |
    #    - - - - - - | - - - - - - - - - - - | - - - - - - - - - - - - | - - - - - - - - - - - - - - - - |
    #    168150976   | UIImageView           | logo                    | {l: 60, t: 10, w: 200, h: 95.5} |
    #    168128784   | UIView                | 0                       |                                 |
    #    - - - - - - | - - - - - - - - - - - | - - - - - - - - - - - - | - - - - - - - - - - - - - - - - |
    #    168180640   | UIImageView           |                         | {l: 1, t: 1, w: 148, h: 19}     |
    #    168173616   | UIRoundedRectButton   | 0                       |                                 |
    #    - - - - - - | - - - - - - - - - - - | - - - - - - - - - - - - | - - - - - - - - - - - - - - - - |
    #    168204336   | UIImageView           |                         | {l: 1, t: 0, w: 77, h: 27}      |
    #    168201952   | _UISwitchInternalView | 0                       |                                 |
    #    - - - - - - | - - - - - - - - - - - | - - - - - - - - - - - - | - - - - - - - - - - - - - - - - |
    #    172600352   | UIImageView           |                         | {l: -2, t: 0, w: 79, h: 27}     |
    #    168204512   | UIView                | 0                       |                                 |
    #    - - - - - - | - - - - - - - - - - - | - - - - - - - - - - - - | - - - - - - - - - - - - - - - - |
    #    168205504   | UIImageView           |                         | {l: -2, t: 0, w: 131, h: 27}    |
    #    168204512   | UIView                | 0                       |                                 |
    #    - - - - - - | - - - - - - - - - - - | - - - - - - - - - - - - | - - - - - - - - - - - - - - - - |
    #    168205600   | UIImageView           |                         | {l: 49, t: 0, w: 29, h: 27}     |
    #    168204512   | UIView                | 0                       |                                 |
    #    - - - - - - | - - - - - - - - - - - | - - - - - - - - - - - - | - - - - - - - - - - - - - - - - |
    #    RMQ 278442176. 6 selected. selectors: [UIImageView]#
    def log(opt = nil)
      wide = (opt == :wide)
      out =  "\n object_id   | class                 | style_name              | frame                           |"
      out << "\n" unless wide
      out <<   " sv id       | superview             | subviews count          | tags                            |"
      line =   " - - - - - - | - - - - - - - - - - - | - - - - - - - - - - - - | - - - - - - - - - - - - - - - - |\n"
      out << "\n"
      out << line.chop if wide
      out << line

      selected.each do |view| 
        out << " #{view.object_id.to_s.ljust(12)}|"
        out << " #{view.class.name[0..21].ljust(22)}|"
        out << " #{(view.rmq_data.style_name || '')[0..23].ljust(24)}|"

        s = ""
        if view.origin
          format = '#0.#'
          s = " {l: #{RMQ.format.numeric(view.origin.x, format)}"
          s << ", t: #{RMQ.format.numeric(view.origin.y, format)}"
          s << ", w: #{RMQ.format.numeric(view.size.width, format)}"
          s << ", h: #{RMQ.format.numeric(view.size.height, format)}}"
        end
        out << s.ljust(33)
        out << '|'

        out << "\n" unless wide
        out << " #{view.superview.object_id.to_s.ljust(12)}|"
        out << " #{(view.superview ? view.superview.class.name : '')[0..21].ljust(22)}|"
        out << " #{view.subviews.length.to_s.ljust(23)} |"
        #out << "  #{view.subviews.length.to_s.rjust(8)} #{view.superview.class.name.ljust(20)} #{view.superview.object_id.to_s.rjust(10)}"
        out << " #{view.rmq_data.tag_names.join(',').ljust(32)}|"
        out << "\n"
        out << line unless wide
      end

      out << "RMQ #{self.object_id}. #{self.count} selected. selectors: #{self.selectors.to_s}"

      puts out
    end

    class << self
      attr_accessor :cache_controller_rmqs
      @cache_controller_rmqs = true
    end

    protected 
    def extract_views_from_selectors(view_container, working_selectors)
      unless RMQ.is_blank?(working_selectors)
        working_selectors.each do |selector|
          if selector.is_a?(UIView)
            view_container << working_selectors.delete(selector)
          end
        end
      end
      [view_container, working_selectors]
    end

    def all_subviews_for(view)
      # TODO maybe cache this, and invalidate cache properly
      out = []
      if view.subviews
        view.subviews.each do |subview|
          out << subview
          out << all_subviews_for(subview)
        end
        out.flatten!
      end

      out
    end

    def all_superviews_for(view, out = [])
      if (nr = view.nextResponder) && nr.is_a?(UIView)
        out << nr
        all_superviews_for(nr, out)
      end     
      out
    end

  end
end
