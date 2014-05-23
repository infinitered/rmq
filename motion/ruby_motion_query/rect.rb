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

    # Always applied in this order, regardles of the hash order:
    # l, t, w, h
    # grid
    # previous
    # from_right, from_bottom
    # right, bottom
    # left and right applied together (will change width)
    # top and bottom applied together (will change height)
    # centered
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
    # rmq(my_view).frame = {l: 10, t: 10, r: 10, b: 10}
    # rmq(my_view).frame = {width: 50, height: 20, centered: :both}
    # rmq(my_view).frame = "a1:b5"
    # rmq(my_view, my_other_view).frame = {grid: "b2", w: 100, h: 200}
    # rmq(my_view, my_other_view).frame = {left: "b", top: "2", right: "d", bottom: "3"}
    # rmq(my_other_view).frame = {left: "b", top: "2", right: 200, bottom: 300}
    def frame=(value)
      selected.each do |view| 
        Rect.update_view_frame(view, value)
      end
    end

    def bounds
      if selected.length == 1
        Rect.bounds_for_view(selected.first)
      else
        selected.map{|s| Rect.bounds_for_view(s)}
      end
    end

    def bounds=(value)
      selected.each do |view| 
        Rect.bounds_for_view(view).update(value, self.grid).apply_to_bounds
      end
    end

  end


  # RMQ Rect   
  #
  #    *******************---*******---***************************   value options
  #    *                   |         |                           *   -------------
  #    *                   |         |                           *   integer
  #    *                   |         |                           *   signed integer
  #    *                  top        |                           *   float
  #    *                   |         |                           *   :prev
  #    *                   |         |                           *   'a1:b4' 
  #    *                  ---        |                           *   'a1' 
  #    *              ***************|*****   ---                *   'a'
  #    *              * view         |    *    |                 *   '1'
  #    *              *              |    *    |                 *   ':b4'
  #    *              *           bottom  *    |                 *   
  #    *              *              |    *    |                 *   additional size options 
  #    *|--- left ---|*              |    *    |                 *   -----------------------
  #    *              *              |    * height               *   :full
  #    *              *              |    *    |                 *   :right_of_prev  (:rop)
  #    *              *              |    *    |                 *   :left_of_prev   (:lop)
  #    *|-------------------- right -+---|*    |                 *   :below_prev     (:bp)                
  #    *              *              |    *    |                 *   :above_prev     (:ap)
  #    *              *              |    * |--+--from_right----|*   
  #    *              *             ---   *    |                 *   abbreviations
  #    *              ***************---***   ---                *   -----------------------
  #    *                              |                          *   :l, :t, :w, :h      
  #    *              |------ width - + -|                       *   :r, :b
  #    *                              |                          *   :fr, fb
  #    *                              |                          *   
  #    *                          from_bottom                    *   centered options
  #    *                              |                          *   ---------
  #    *                              |                          *   :horizontal
  #    *                             ---                         *   :vertical
  #    ***********************************************************   :both            
  #
  class Rect
    attr_reader :view

    class << self

      def update_view_frame(view, params)
        view.frame = object_to_cg_rect(params, view, view.frame)
      end

      def update_view_bounds(view, params)
        view.frame = object_to_cg_rect(params, view, view.bounds)
      end

      def frame_for_view(view)
        Rect.new(view.frame, view)
      end

      def bounds_for_view(view)
        Rect.new(view.bounds, view)
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
          #if point_or_rect = grid[string]
            #if point_or_rect.is_a?(CGPoint)
              #@left = point_or_rect.x
              #@top = point_or_rect.y
            #else
              #update point_or_rect, grid
            #end
          #end
        else
          o # Arrays, CGRect, etc
        end
      end

      # Used internally, don't use this
      #
      # In singleton for performance # TODO, test if this is necessary
      def rect_hash_to_rect_array(view, existing_rect, params, grid = nil)
        params_l = params[:l] || params[:left] || params[:x]
        l = params_l || existing_rect.origin.x

        params_t = params[:t] || params[:top] || params[:y]
        t = params_t || existing_rect.origin.y

        params_w = params[:w] || params[:width]
        w = params_w || existing_rect.size.width

        params_h = params[:h] || params[:height]
        h = params_h || existing_rect.size.height

        r = params[:r] || params[:right]
        b = params[:b] || params[:bottom]

        fr = params[:from_right] || params[:fr]
        fb = params[:from_bottom] || params[:fb]

        # Grid
        # TODO

        # Previous view
        # TODO

        if sv = view.superview
          sv_size = sv.bounds.size
        end

        # From right, from_bottom
        if (fr || fb) && sv
          if fr
            if params_w
              l = sv_size.width - w - fr
            else
              w = sv_size.width - l - fr
            end
          end

          if fb
            if params_h
              t = sv_size.height - h - fb
            else
              h = sv_size.height - t - fb
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
        if sv && (centered = params[:centered])
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
      cg_rect = Rect.object_to_cg_rect(params, @view, self.to_cgrect, grid)

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
 *            *              |    *    |    #{fr}       *
 *            *              |    * |--+--from_right---|*
 *            *             ---   *    |                *
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
