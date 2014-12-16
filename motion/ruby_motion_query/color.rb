module RubyMotionQuery
  class RMQ
    # @param color value options
    # @return [UIColor]
    # @example
    #   color('#ffffff')
    #   color('ffffff')
    #   color('#336699cc')
    #   color('369c')
    #   color(255,255,255,0.5)
    #   color(r: 255,g: 255,b: 255,a: 0.5)
    #   color(red: 255,green: 255,blue: 255,alpha: 0.5)
    #   color.from_hsva(h: 100,s: 140,b: 80,a: 1.0)
    def self.color(*params)
      if params.empty?
        Color
      else
        ColorFactory.build(params)
      end
    end

    # @param color value options
    # @return [UIColor]
    # @example
    #   color('#ffffff')
    #   color('ffffff')
    #   color('#336699cc')
    #   color('369c')
    #   color(255,255,255,0.5)
    #   color(r: 255,g: 255,b: 255,a: 0.5)
    #   color(red: 255,green: 255,blue: 255,alpha: 0.5)
    #   color.from_hsva(h: 100,s: 140,b: 80,a: 1.0)
    def color(*params)
      self.class.color(*params)
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
          ColorFactory.from_hex(hex_or_color)
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
        ColorFactory.from_hex(str)
      end

      # @return [UIColor]
      #
      # @example
      #   rmq.color.from_rgba(255,255,255,0.5)
      def from_rgba(r,g,b,a)
        ColorFactory.from_rgba(r,g,b,a)
      end

      # @return [UIColor]
      #
      # @example
      #   rmq.color.from_hsva(100,140,80,1.0)
      def from_hsva(h,s,v,a)
        ColorFactory.from_hsva(h,s,v,a)
      end

      def random
        ColorFactory.from_rgba(rand(255), rand(255), rand(255), 1.0)
      end
    end
  end

  class ColorFactory
    def self.build(params)
      return Color if params.empty?
      return from_rgba(*params) if params.count > 1

      param = params.first
      return from_hex(params.join) if param.is_a?(String)

      return from_base_color(param) if base_values(param)
      return try_rgba(param) if rgba_values(param)
      return try_hsva(param) if hsva_values(param)
      return try_hex(param) if hex_values(param)
    end

    def self.from_base_color(values)
      base = values[:base] || values[:color]
      r, g, b, a = Pointer.new('d'), Pointer.new('d'), Pointer.new('d'), Pointer.new('d')
      base.getRed(r, green: g, blue: b, alpha: a)

      r = values[:r] || values[:red] || r.value
      g = values[:g] || values[:green] || g.value
      b = values[:b] || values[:blue] || b.value
      a = values[:a] || values[:alpha] || a.value

      UIColor.colorWithRed(r, green: g, blue: b, alpha: a)
    end

    def self.try_rgba(values)
      r = values[:red] || values[:r]
      g = values[:green] || values[:g]
      b = values[:blue] || values[:b]
      a = values[:alpha] || values[:a] || 1.0
      raise ArgumentError unless r && g && b && a

      from_rgba(r, g, b, a)
    end

    def self.try_hsva(values)
      h = values[:hue] || values[:h]
      s = values[:saturation] || values[:s]
      v = values[:brightness] || values[:b]
      a = values[:alpha] || values[:a] || 1.0
      raise ArgumentError unless h && s && s && v && a

      Color.from_hsva(h, s, v, a)
    end

    def self.try_hex(values)
      hex = values[:hex] || values[:x]
      alpha = values[:alpha] || values[:a]

      color = from_hex(hex)
      color = color.colorWithAlphaComponent(alpha) if alpha
      color
    end

    def self.rgba_values(values)
      values[:red] || values[:r] || values[:green] || values[:g] || values[:blue]
    end

    def self.base_values(values)
      values[:base] || values[:color]
    end

    def self.hsva_values(values)
      values[:hue] || values[:h] || values[:saturation] || values[:s] || values[:brightness]
    end

    def self.hex_values(values)
      values[:hex] || values[:x]
    end

    def self.from_rgba(r,g,b,a=1.0)
      UIColor.colorWithRed((r/255.0), green: (g/255.0), blue: (b/255.0), alpha: a)
    end

    def self.from_hex(str)
      r,g,b,a = case (str =~ /^#?(\h{3,8})$/ && $1.size)
                when 3, 4 then $1.scan(/./ ).map {|c| (c*2).to_i(16) }
                when 6, 8 then $1.scan(/../).map {|c|     c.to_i(16) }
                else raise ArgumentError
                end
      from_rgba(r, g, b, a ? (a/255.0) : 1.0)
    end

    def self.from_hsva(h,s,v,a)
      UIColor.alloc.initWithHue(h, saturation: s, brightness: v, alpha: a)
    end
  end
end
