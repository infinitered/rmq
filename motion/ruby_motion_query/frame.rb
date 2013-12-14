module RubyMotionQuery
  class RMQ
    def frame=(value)
      #if value.is_a?(Frame)
        
      #else

      #end
    end

    def frame
      if selected.length == 1
        selected.first.rmq_data.frame
      else
        selected.map{|s| s.rmq_data.frame}
      end
    end
  end

  # RMQ Frame   
  #
  #    *******************---*******---***************************   value options
  #    *                   |         |                           *   -------------
  #    *                   |         |                           *   integer
  #    *                   |         |                           *   signed integer
  #    *                  top        |                           *   float
  #    *                   |         |                           *   :prev
  #    *                   |         |                           *    
  #    *                  ---        |                           *   additional size options
  #    *              ***************|*****   ---                *   -----------------------
  #    *              * view         |    *    |                 *   :full
  #    *              *              |    *    |                 *   :half
  #    *              *           bottom  *    |                 *   :quarter
  #    *              *              |    *    |                 *
  #    *|--- left ---|*              |    *    |                 *   centered options
  #    *              *              |    * height               *   ---------
  #    *              *              |    *    |                 *   :horizontal
  #    *              *              |    *    |                 *   :vertical
  #    *|-------------------- right -+---|*    |                 *   :both
  #    *              *              |    *    |                 *
  #    *              *              |    * |--+--from_right----|*
  #    *              *             ---   *    |                 *
  #    *              ***************---***   ---                *
  #    *                              |                          *
  #    *              |------ width - + -|                       *
  #    *                              |                          *
  #    *                              |                          *
  #    *                          from_bottom                    *
  #    *                              |                          *
  #    *                              |                          *
  #    *                             ---                         *
  #    ***********************************************************
  #
  class Frame
    def initialize(view, params = {})
      @view = RubyMotionQuery::RMQ.weak_ref(view)
      change(params)
    end

    def change(params = {})
    end

    def size
      @view.frame.size
    end
    def height
      size.height
    end
    alias :h :height
    def width
      size.width
    end
    alias :w :width


    def origin
      @view.frame.origin
    end

    def left
      origin.x
    end
    alias :l :left

    def right
      left + width
    end
    alias :r :right

    def from_right
      if sv = @view.superview
        sv.size.width - right
      end
    end

    def top
      origin.y
    end
    alias :t :top

    def bottom
      top + height
    end
    alias :b :bottom

    def from_bottom
      if sv = @view.superview
        sv.size.height - bottom
      end
    end

    def above_prev
    end
    def below_prev
    end
    def left_of_prev
    end
    def right_of_prev
    end

    def prev_top
    end
    def prev_buttom
    end
    def prev_left
    end
    def prev_right
    end


    def center
    end
    def centered
    end

    # no = on these
    def pad
    end
    def pad_left
    end
    def pad_right
    end
    def pad_top
    end
    def pad_bottom
    end

    def resize_to_fit_subviews
    end

    def location_in_window
    end

    def location_in(view)
    end

    def z_order
      rmq(@view).parent.children.to_a.index(@view)
    end

    def z_position
      @view.layer.zPosition
    end

    def log
      def i_f_to_s(int_or_float)
        if int_or_float % 1 == 0
          int_or_float.to_i.to_s
        else
          int_or_float.to_s
        end
      end

      l = i_f_to_s(left).ljust(5)
      t = i_f_to_s(top).rjust(5)
      w = i_f_to_s(width).ljust(5)
      h = i_f_to_s(height).ljust(5)
      b = i_f_to_s(bottom).rjust(5)
      r = i_f_to_s(right).ljust(5)
      fr = i_f_to_s(from_right).ljust(5)
      fb = i_f_to_s(from_bottom).rjust(5)

      ww = i_f_to_s(rmq.app.window.size.width)
      wh = i_f_to_s(rmq.app.window.size.height)

      if sv = @view.superview
        sw = i_f_to_s(sv.size.width)
        sh = i_f_to_s(sv.size.height)
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

    def inspect
      format = '#0.#'
      s = "Frame {l: #{RMQ.format.numeric(left, format)}"
      s << ", t: #{RMQ.format.numeric(top, format)}"
      s << ", w: #{RMQ.format.numeric(width, format)}"
      s << ", h: #{RMQ.format.numeric(height, format)}}"
      s
    end
  end
end
