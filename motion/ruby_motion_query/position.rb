module RubyMotionQuery
  class RMQ

    # @return [RMQ]
    def move(opts) 
      # TODO, add centered and from_bottom and from_top, and bottom and top
      # TODO, add animate option
      left = opts[:left] || opts[:l] || opts[:x]
      top = opts[:top] || opts[:t] || opts[:y]
      width = opts[:width] || opts[:w]
      height = opts[:height] || opts[:h]

      selected.each do |view|
        view.frame = [
          [left || view.origin.x, top || view.origin.y],
          [width || view.size.width, height || view.size.height]
        ]
      end

      self
    end
    alias :resize :move

    # @return [RMQ]
    def nudge(opts) 
      left = opts[:left] || opts[:l] || 0
      right = opts[:right] || opts[:r] || 0
      up = opts[:up] || opts[:u] || 0
      down = opts[:down] || opts[:d] || 0

      selected.each do |view|
        f = view.frame
        f.origin = [view.origin.x - left + right, view.origin.y + down - up]
        view.frame = f
      end

      self
    end

  end
end
