module RubyMotionQuery
  class RMQ
    # @return [Color]
    def self.color(*params)
      return Color if params.empty?

      if params.count == 1
        param = params.first
        if param.is_a?(Hash)
          color = Color.from_hex(param[:x] || param[:hex])
          if alpha = param[:a] || param[:alpha]
            color = color.colorWithAlphaComponent(alpha)
          end

          color
        else
          Color.from_hex(params.join)
        end
      end
    end

    # @return [Color]
    def color
      self.class.color
    end
  end

  # @example
  #   # Standard colors:
  #
  #   # In a stylesheet, you can just use color. Anywhere else these would be
  #   # rmq.color.clear, etc
  #
  #   color.clear
  #   color.white
  #   color.light_gray
  #   color.gray
  #   color.dark_gray
  #   color.black
  #
  #   color.red
  #   color.green
  #   color.blue
  #   color.yellow
  #   color.orange
  #   color.purple
  #   color.brown
  #   color.cyan
  #   color.magenta
  #
  #   color.table_view
  #   color.scroll_view
  #   color.flipside
  #   color.under_page
  #   color.light_text
  #   color.dark_text
  class Color < UIColor

    class << self
      alias :clear         :clearColor
      alias :white         :whiteColor
      alias :light_gray    :lightGrayColor
      alias :gray          :grayColor
      alias :dark_gray     :darkGrayColor
      alias :black         :blackColor

      alias :red           :redColor
      alias :green         :greenColor
      alias :blue          :blueColor
      alias :yellow        :yellowColor
      alias :orange        :orangeColor
      alias :purple        :purpleColor
      alias :brown         :brownColor
      alias :cyan          :cyanColor
      alias :magenta       :magentaColor

      alias :table_view    :groupTableViewBackgroundColor
      alias :scroll_view   :scrollViewTexturedBackgroundColor
      alias :flipside      :viewFlipsideBackgroundColor
      alias :under_page    :underPageBackgroundColor
      alias :light_text    :lightTextColor
      alias :dark_text     :darkTextColor

      # Add your own standard color
      #
      # @return [UIColor]
      #
      # @example
      #   rmq.color.add_named(:foo, '#ffffff')
      #   my_label.color = rmq.color.foo # or just color.foo in a stylesheet
      def add_named(key, hex_or_color)
        color = if hex_or_color.is_a?(String)
          Color.from_hex(hex_or_color)
        else
          hex_or_color
        end

        Color.define_singleton_method(key) do
          color
        end
      end

      # Creates a color from a hex triplet (rgb) or quartet (rgba)
      #
      # @param hex with or without the #
      # @return [UIColor]
      # @example
      #   color.from_hex('#ffffff')
      #   color.from_hex('ffffff')
      #   color.from_hex('#336699cc')
      #   color.from_hex('369c')
      def from_hex(str)
        r,g,b,a = case (str =~ /^#?(\h{3,8})$/ && $1.size)
          when 3, 4 then $1.scan(/./ ).map {|c| (c*2).to_i(16) }
          when 6, 8 then $1.scan(/../).map {|c|     c.to_i(16) }
          else raise ArgumentError
        end
        from_rgba(r, g, b, a ? (a/255.0) : 1.0)
      end

      # @return [UIColor]
      #
      # @example
      #   rmq.color.from_rgba(255,255,255,0.5)
      def from_rgba(r,g,b,a)
        UIColor.colorWithRed((r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
      end

      # @return [UIColor]
      #
      # @example
      #   rmq.color.from_hsva(100,140,80,1.0)
      def from_hsva(h,s,v,a)
        UIColor.alloc.initWithHue(h, saturation: s, brightness: v, alpha: a)
      end

      def random
        from_rgba(rand(255), rand(255), rand(255), 1.0)
      end
    end

  end
end
