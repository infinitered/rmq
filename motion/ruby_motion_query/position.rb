module RubyMotionQuery
  class RMQ

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
    # rmq.append(UILabel).layout(l: 10, t: 100, w: 100, h: 18)
    # rmq(my_view).move(l: 10, t: 100)
    # rmq(my_view).resize(h: 10, w: 100)
    # rmq(my_view).layout :full
    # rmq(my_view).layout(l: 10, t: 20, w: 100, h: 150)
    # rmq(my_view).layout(t: 20, h: 150, l: 10, w: 100)
    # rmq(my_view).layout(l: 10, t: 20)
    # rmq(my_view).layout(h: 20)
    # rmq(my_view).layout(l: :prev, t: 20, w: 100, h: 150)
    # rmq(my_view).layout(l: 10, below_prev: 10, w: prev, h: 150)
    # rmq(my_view).layout(left: 10, top: 20, width: 100, height: 150)
    # rmq(my_view).layout(l: 10, t: 10, fr: 10, fb: 10)
    # rmq(my_view).layout(width: 50, height: 20, centered: :both)
    # rmq(my_view).layout("a1:b5").show
    # rmq(my_view, my_other_view).layout grid: "b2", w: 100, h: 200
    # rmq(my_view, my_other_view).layout g: "b2", w: 100, h: 200
    #
    # @example with padding
    # mq(my_view).layout(grid: "b2:d14", padding: 5)
    # mq(my_view).layout(grid: "b2:d14", padding: {l: 5, t: 0, r: 5, b:0})
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
        rect = view.rmq.frame

        view_margin = if (margins && margins[i])
          margins[i]
        else
          margin
        end

        t = rect.top
        l = rect.left

        if type == :vertical
          current_end = (rect.top - view_margin) unless current_end
          t = current_end + view_margin
          current_end = t + rect.height
        else
          current_end = (rect.left - view_margin) unless current_end
          l = current_end + view_margin
          current_end = l + rect.width
        end

        view.rmq.layout(l: l, t: t)
      end

      self
    end

    def resize_to_fit_subviews
      selected.each do |view|
        w = 0
        h = 0

        view.subviews.each do |subview|
          rect = subview.rmq.frame
          w = [rect.right, w].max
          h = [rect.bottom, h].max
        end

        rect = view.rmq.frame
        w = rect.width if w == 0
        h = rect.height if h == 0

        view.rmq.layout(w: w, h: h)
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
