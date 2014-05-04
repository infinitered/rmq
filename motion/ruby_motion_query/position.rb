module RubyMotionQuery
  class RMQ

    # @example
    #   rmq.append(UILabel).layout(l: 10, t: 100, w: 100, h: 18)
    #   rmq(my_view).move(l: 10, t: 100)
    #   rmq(my_view).resize(h: 10, w: 100)
    #
    # @return [RMQ]
    def layout(params) 
      selected.each do |view|
        RubyMotionQuery::Rect.update_view_frame(view, params)
      end

      self
    end
    alias :move :layout
    alias :resize :layout

    # @return [RMQ]
    # TODO move nudge implementation into Rect
    def nudge(params) 
      left = params[:left] || params[:l] || 0
      right = params[:right] || params[:r] || 0
      up = params[:up] || params[:u] || 0
      down = params[:down] || params[:d] || 0

      selected.each do |view|
        f = view.frame
        f.origin = [view.origin.x - left + right, view.origin.y + down - up]
        view.frame = f
      end

      self
    end

    # @example
    #   rmq(UIButton).distribute
    #   rmq(UIButton).distribute(:vertical)
    #   rmq(UIButton).distribute(:horizontal)
    #   rmq(UIButton).distribute(:vertical, margin: 20)
    #   rmq(my_view, my_other_view, third_view).distribute(:vertical, margin: 10)
    #   rmq(UIButton).distribute(:vertical, margins: [5,5,10,5,10,5,10,20])
    #
    # @return [RMQ]
    def distribute(type = :vertical, params = {})
      return 0 if selected.length == 0

      margins = params[:margins]
      margin = params[:margin] || 0
      current_end = nil

      selected.each_with_index do |view, i|
        st = self.styler_for(view)

        if type == :vertical
          next if st.height == 0
        else
          next if st.width == 0
        end

        view_margin = if (margins && margins[i])
          margins[i]
        else
          margin
        end

        if type == :vertical
          current_end = (st.top - view_margin) unless current_end
          st.top = current_end + view_margin
          current_end = st.bottom
        else
          current_end = (st.left - view_margin) unless current_end
          st.left = current_end + view_margin
          current_end = st.right
        end
      end

      self
    end

    def resize_to_fit_subviews
      selected.each do |view|
        st = self.styler_for(view)

        w = 0
        h = 0

        view.subviews.each do |subview|
          sub_st = self.styler_for(subview)
          w = [sub_st.right, w].max
          h = [sub_st.bottom, h].max
        end

        st.width = w if st.width < w
        st.height = h if st.height < h
      end

      self
    end

    # @return [Array] or [CGSize]
    def location_in_root_view
      self.location_in(self.root_view)
    end

    # @return [Array] or [CGSize]
    def location_in(view)
      out = []
      selected.each do |selected_view|
        out << selected_view.convertRect(selected_view.bounds, toView: view).origin
      end
      out = out.first if out.length == 1
      out
    end

  end
end
