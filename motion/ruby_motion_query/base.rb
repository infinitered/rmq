module RubyMotionQuery
  class RMQ
    attr_accessor :context, :parent_rmq

    def initialize
      @selected_dirty = true
    end

    def selected=(value)
      @_selected = value
      @selected_dirty = false
    end
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
    # rmq(foo).parent.get.some_method_on_parent
    def get
      sel = self.selected
      if sel.length == 1
        sel.first
      else
        sel
      end
    end

    def root?
      (selected.length == 1) && (selected.first == @context)
    end

    def context_or_context_view
      if @context.is_a?(UIViewController)
        @context.view
      else
        @context
      end
    end

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

    def inspect
      out = "RMQ #{self.object_id}. #{self.count} selected. selectors: #{self.selectors.to_s}. .log for more info"
      out << "\n[#{selected.first}]" if self.count == 1
      out
    end

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
  end
end
