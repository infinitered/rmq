module RubyMotionQuery

  class RMQ
    # @return RubyMotionQuery::Rect or array of RubyMotionQuery::Rect
    #
    # @example
    # left = rmq(my_view).frame.left
    def frame(params = nil)
      if params
        frame = params
        self
      else
        if selected.length == 1
          Rect.frame_for_view(selected.first)
        else
          selected.map{|s| Rect.frame_for_view(s)}
        end
      end
    end

    # Same as layout:
    #   rmq(my_view).layout(l: 10, t: 20, w: 100, h: 150)
    #
    # Always applied in this order, regardless of the hash order:
    #   grid
    #   l, t, w, h
    #   previous
    #   from_right, from_bottom
    #   right, bottom
    #   left and right applied together (will change width)
    #   top and bottom applied together (will change height)
    #   centered
    #   padding
    #
    # @example
    # rmq(my_view).frame = :full
    # rmq(my_view).frame = {l: 10, t: 20, w: 100, h: 150}
    # rmq(my_view).frame = {t: 20, h: 150, l: 10, w: 100}
    # rmq(my_view).frame = {l: 10, t: 20}
    # rmq(my_view).frame = {h: 20}
    # rmq(my_view).frame = {l: :prev, t: 20, w: 100, h: 150}
    # rmq(my_view).frame = {l: 10, below_prev: 10, w: prev, h: 150}
    # rmq(my_view).frame = {left: 10, top: 20, width: 100, height: 150}
    # rmq(my_view).frame = {l: 10, t: 10, fr: 10, fb: 10}
    # rmq(my_view).frame = {width: 50, height: 20, centered: :both}
    # rmq(my_view).frame = "a1:b5"
    # rmq(my_view, my_other_view).frame = {grid: "b2", w: 100, h: 200}
    # rmq(my_view, my_other_view).frame = {g: "b2", w: 100, h: 200}
    # 
    # @example with padding
    # rmq(my_view).frame = {grid: "b2:d14", padding: 5}
    # rmq(my_view).frame = {grid: "b2:d14", padding: {l: 5, t: 0, r: 5, b:0}}
    def frame=(value)
      selected.each do |view| 
        RubyMotionQuery::Rect.update_view_frame(view, value)
      end
    end

    def bounds
      if selected.length == 1
        RubyMotionQuery::Rect.bounds_for_view(selected.first)
      else
        selected.map{|s| Rect.bounds_for_view(s)}
      end
    end

    def bounds=(value)
      selected.each do |view| 
        RubyMotionQuery::Rect.bounds_for_view(view).update(value, self.grid).apply_to_bounds
      end
    end

  end


  # RMQ Rect   
  #
  #    *******************---*******---***************************   value options
  #    *                   |         |                           *   -------------
  #    *                   |         |                           *   Integer
  #    *                   |         |                           *   signed Integer
  #    *                  top        |                           *   Float
  #    *                   |         |                           *   String
  #    *                   |         |                           *   
  #    *                  ---        |                           *   also                    
  #    *              ***************|*****   ---                *   -----------------------
  #    *              * view         |    *    |                 *   :full
  #    *              *              |    *    |                 *   :right_of_prev  (:rop)         
  #    *              *           bottom  *    |                 *   :left_of_prev   (:lop)
  #    *              *              |    *    |                 *   :below_prev     (:bp)  
  #    *|--- left ---|*              |    *    |                 *   :above_prev     (:ap)
  #    *              *              |    * height               *   :grid           (:g)
  #    *              *              |    *    |                 *   :padding        (:p)
  #    *              *              |    *    |                 *     int or hash: l,t,b,r 
  #    *|-------------------- right -+---|*    |                 *                 
  #    *              *              |    *    |                 *   abbreviations           
  #    *              *              |    * |--+--from_right----|*   -----------------------
  #    *              *             ---   *    |                 *   :l, :t, :w, :h         
  #    *              ***************---***   ---                *   :r, :b
  #    *                              |                          *   :fr, fb
  #    *              |------ width - + -|                       *   
  #    *                              |                          *   :centered options
  #    *                              |                          *   -----------------------
  #    *                          from_bottom                    *   :horizontal
  #    *                              |                          *   :vertical
  #    *                              |                          *   :both                  
  #    *                             ---                         *   
  #    ***********************************************************       
  #
  class Rect
    attr_reader :view

    class << self

      def update_view_frame(view, params)
        view.frame = object_to_cg_rect(params, view, view.frame, view.rmq.grid)
        @_previous_view = RubyMotionQuery::RMQ.weak_ref(view)
      end

      def update_view_bounds(view, params)
        view.frame = object_to_cg_rect(params, view, view.bounds, view.rmq.grid)
        @_previous_view = RubyMotionQuery::RMQ.weak_ref(view)
      end

      # The previous view is literally the last view that was layed out, not
      # the sibling view, the last view layed out in this screen, etc, just 
      # the last view.
      # As styles and layouts are always applied in order, and there is only
      # 1 UI thread, this should work just fine
      def previous_view
        # TODO, verify that there is actually a problem with circular reference here
        # if not, we can just store the view and not create a weakref
        RubyMotionQuery::RMQ.weak_ref_value(@_previous_view)
      end

      def frame_for_view(view)
        new(view.frame, view)
      end

      def bounds_for_view(view)
        new(view.bounds, view)
      end

      # Used internally, don't use this
      #
      # In singleton for performance # TODO, test if this is necessary
      def object_to_cg_rect(o, view = nil, existing_rect = nil, grid = nil)
        if o.is_a?(Hash)
          a = rect_hash_to_rect_array(view, existing_rect, o, grid)
          CGRectMake(a[0], a[1], a[2], a[3])
        elsif o == :full
          if view
            view.superview.bounds
          else
            rmq.rootview.bounds
          end
        elsif o.is_a?(RubyMotionQuery::Rect)
          o.to_cgrect
        elsif grid && o.is_a?(String) 
          a = rect_hash_to_rect_array(view, existing_rect, {grid: o}, grid)
          CGRectMake(a[0], a[1], a[2], a[3])
        elsif o.is_a?(Array)
          case o.length
          when 4
            CGRectMake(o[0], o[1], o[2], o[3])
          when 2
            o
          end
        else
          o # CGRect, etc
        end
      end

      # Used internally, don't use this
      #
      # In singleton for performance # TODO, test if this is necessary
      def rect_hash_to_rect_array(view, existing_rect, params, grid = nil)
        # TODO check if this is performant, it should be
        if (sv = view.superview) && (vc = view.rmq_data.view_controller)
          not_in_root_view = !(vc.view == sv)
        end

        # Grid
        if grid
          if params_g = params[:grid] || params[:g]
            params.delete(:grid)
            params.delete(:g)

            grid_h = grid[params_g]
            params = grid_h.merge(params)
          end
        end

        params_l = params[:l] || params[:left] || params[:x]
        params_t = params[:t] || params[:top] || params[:y]
        params_w = params[:w] || params[:width]
        params_h = params[:h] || params[:height]

        below_prev = params[:below_prev] || params[:bp] || params[:below_previous]
        above_prev = params[:above_prev] || params[:ap]  || params[:above_previous]
        right_of_prev = params[:right_of_prev] || params[:rop] || params[:right_of_previous]
        left_of_prev = params[:left_of_prev] || params[:lop] || params[:left_of_previous]

        l = params_l || existing_rect.origin.x
        t = params_t || existing_rect.origin.y
        w = params_w || existing_rect.size.width
        h = params_h || existing_rect.size.height

        r = params[:r] || params[:right]
        b = params[:b] || params[:bottom]

        fr = params[:from_right] || params[:fr]
        fb = params[:from_bottom] || params[:fb]

        centered = params[:centered]

        # Previous
        if prev_view = previous_view
          if params_g && (prev_sv = prev_view.superview) 

            previous_root_view_point = vc.view.convertPoint(prev_view.origin, fromView: prev_sv)

            if below_prev
              t = params_t = previous_root_view_point.y + prev_view.frame.size.height + below_prev
            elsif above_prev
              t = params_t = previous_root_view_point.y - above_prev - h
            end

            if right_of_prev
              l = params_l = previous_root_view_point.x + prev_view.frame.size.width + right_of_prev
            elsif left_of_prev
              l = params_l = previous_root_view_point.x - left_of_prev - w
            end

          else
            if below_prev
              t = prev_view.frame.origin.y + prev_view.frame.size.height + below_prev
            elsif above_prev
              t = prev_view.frame.origin.y - above_prev - h
            end

            if right_of_prev
              l = prev_view.frame.origin.x + prev_view.frame.size.width + right_of_prev
            elsif left_of_prev
              l = prev_view.frame.origin.x - left_of_prev - w
            end
          end
        end

        if sv
          if (fr || fb || centered) # Needs size

            # Horrible horrible hack, TODO fix. This is here because
            # the root_view's height isn't changed until after viewDidLoad when
            # vc.edgesForExtendedLayout = UIRectEdgeNone.
            # Not sure how often people use UIRectEdgeNone as I never do, 
            # perhaps an edge case that should be isolated in some wayo
            # I hate to have to check and calc this every time
            if vc && !not_in_root_view && (vc.edgesForExtendedLayout == UIRectEdgeNone)
              sv_size = CGSizeMake(sv.size.width, rmq.device.screen_height - 64)  
            else
              sv_size = sv.size
            end
          end
        end

        # From right, from_bottom
        if (fr || fb) && sv
          if fr
            if params_l || left_of_prev || right_of_prev
              w = sv_size.width - l - fr
            else
              l = sv_size.width - w - fr
            end
          end

          if fb
            if params_t || below_prev || above_prev
              h = sv_size.height - t - fb
            else
              t = sv_size.height - h - fb
            end
          end
        end

        # Right and bottom
        if r && !fr && !params_l
          l = r - w
        end
        if b && !fb && !params_t
          t = b - h
        end

        # Left and right applied together
        if params_l && r && !params_w
          w = r - l
        end
        # Top and bottom applied together
        if params_t && b && !params_h
          h = b - t
        end

        # Centered, :horizontal, :vertical, :both
        if sv && centered
          case centered
            when :horizontal
              l = (sv_size.width / 2) - (w / 2)
            when :vertical
              t = (sv_size.height / 2) - (h / 2)
            when :both
              l = (sv_size.width / 2) - (w / 2)
              t = (sv_size.height / 2) - (h / 2)
          end
        end

        if padding = params[:padding] || params[:p]
          if padding.is_a?(Hash)
            padding_l = padding[:l] || padding[:left] || 0
            padding_t = padding[:t] || padding[:top] || 0
            padding_r = padding[:r] || padding[:right] || 0
            padding_b = padding[:b] || padding[:bottom] || 0
            l += padding_l
            t += padding_t
            w -= (padding_l + padding_r)
            h -= (padding_t + padding_b)
          else
            l += padding
            t += padding
            w -= (padding * 2)
            h -= (padding * 2)
          end
        end

        if params_g && not_in_root_view # Change to root_view_space
          point = CGPointMake(l,t)
          root_view_point = vc.view.convertPoint(point, toView: sv)
          l = root_view_point.x
          t = root_view_point.y
        end

        [l,t,w,h]
      end

    end # << self

    def initialize(params, view = nil, grid = nil)
      @left = @top = @width = @height = 0
      @view = view
      update params, grid
    end

    def update(params, grid = nil)
      # Doing all of the updates to the Rect in singleton for performance. 
      # It would be better to be done inside an actual Rect instance, but that
      # would require creating a lot of temporary objects.
      # TODO performance and see if there is any real loss bringing 
      # object_to_cg_rect into Rect instance
      #
      # If we did it that way, then we'd create a new instance, then appy the
      # rect instance to the frame or bounds, like so:
      # Rect.new(params, view, grid).apply_to_frame
      cg_rect = RubyMotionQuery::Rect.object_to_cg_rect(params, @view, self.to_cgrect, grid)

      @left = cg_rect.origin.x
      @top = cg_rect.origin.y
      @width = cg_rect.size.width
      @height = cg_rect.size.height
    end

    def apply_to_frame
      @view.frame = to_cgrect if @view
    end
    def apply_to_bounds
      @view.bounds = to_cgrect if @view
    end

    def left
      @left
    end
    alias :l :left
    alias :x :left

    def right
      @left + @width
    end
    alias :r :right

    def from_right
      if @view && (sv = @view.superview)
        sv.size.width - right
      end
    end
    alias :fr :from_right

    def top
      @top
    end
    alias :t :top
    alias :y :top

    def bottom
      @top + @height
    end
    alias :b :bottom

    def from_bottom
      if @view && (sv = @view.superview)
        sv.size.height - bottom
      end
    end
    alias :fb :from_bottom

    def width
      @width
    end
    alias :w :width
    
    def height
      @height
    end
    alias :h :height

    def z_order
      if @view
        @view.superview.subviews.to_a.index(@view) # is there a better way??
      end
    end

    def origin
      to_cgpoint
    end

    def size
      to_cgsize
    end

    def point_in_root_view
      if @view && (sv = @view.superview)  && (vc = view.rmq.view_controller)
        vc.view.convertPoint(CGPointMake(@left,@top), fromView: sv)
      end
    end

    def rect_in_root_view
      if @view && (sv = @view.superview)  && (vc = view.rmq.view_controller)
        point = vc.view.convertPoint(CGPointMake(@left,@top), fromView: sv)
        RubyMotionQuery::Rect.new({l: point.x, t: point.y, w: @view.size.width, h: @view.size.height}, @view)
      end
    end

    def left_in_root_view
      if point = point_in_root_view
        point.x
      end
    end

    def top_in_root_view
      if point = point_in_root_view
        point.y
      end
    end

    # TODO add center

    def z_position
      if @view
        @view.layer.zPosition
      end
    end

    def to_cgpoint
      CGPointMake(@left, @top)
    end

    def to_cgsize
      CGSizeMake(@width, @height)
    end

    def to_cgrect
      CGRectMake(@left, @top, @width, @height)
    end
    def to_a
      [@left, @top, @width, @height]
    end
    def to_h
      {left: @left, top: @top, width: @width, height: @height}
    end

    def inspect
      format = '#0.#'
      s = "Rect {l: #{RMQ.format.numeric(left, format)}"
      s << ", t: #{RMQ.format.numeric(top, format)}"
      s << ", w: #{RMQ.format.numeric(width, format)}"
      s << ", h: #{RMQ.format.numeric(height, format)}}"
      s
    end

    def log
      def i_f_to_s(int_or_float)
        if int_or_float % 1 == 0
          int_or_float.to_i.to_s
        else
          int_or_float.to_s
        end
      end

      l = i_f_to_s(left.round(2)).ljust(5)
      t = i_f_to_s(top.round(2)).rjust(5)
      w = i_f_to_s(width.round(2)).ljust(5)
      h = i_f_to_s(height.round(2)).ljust(5)
      b = i_f_to_s(bottom.round(2)).rjust(5)
      r = i_f_to_s(right.round(2)).ljust(5)
      fr = i_f_to_s(from_right.round(2)).ljust(5)
      fb = i_f_to_s(from_bottom.round(2)).rjust(5)

      ww = i_f_to_s(rmq.app.window.size.width.round(2))
      wh = i_f_to_s(rmq.app.window.size.height.round(2))

      if @view && (sv = @view.superview)
        sw = i_f_to_s(sv.size.width.round(2))
        sh = i_f_to_s(sv.size.height.round(2))
      end

      out = %(
 *****************---*******---**************************  
 *                 |         |                          *    window
 *          #{ t} top        |                          *    {w: #{ww}, h: #{wh}}
 *                 |         |                          *
 *                ---        |                          *    superview 
 *            ***************|*****   ---               *    {w: #{sw}, h: #{sh}} 
 *            *              |    *    |                *
 *            *              |    *    |                *
 *            *     #{ b} bottom  *    |                *    view
 *    #{ l}   *              |    *    |                *    {l: #{l.strip}, t: #{t.strip},
 *|-- left --|*              |    *    |                *     w: #{w.strip}, h: #{h.strip}}
 *            *              |    * height #{ h}        *
 *            *              |    *    |                *    z_order: #{z_order}
 *            *       #{ r}  |    *    |                *    z_position: #{z_position}
 *|------------------ right -+---|*    |                *
 *            *              |    *    |    #{fr}       *    Location in root view
 *            *              |    * |--+--from_right---|*    {l: #{i_f_to_s(left_in_root_view)}, t: #{i_f_to_s(top_in_root_view)},
 *            *             ---   *    |                *     w: #{w.strip}, h: #{h.strip}}
 *            ***************---***   ---               *
 *                            |                         *
 *            |------ width - + --|                     *
 *                    #{ w}   |                         *
 *                            |                         *
 *                            |                         *
 *                  #{fb} from_bottom                   *
 *                            |                         *
 *                           ---                        *
 ********************************************************
)
      puts out
    end

  end
end
