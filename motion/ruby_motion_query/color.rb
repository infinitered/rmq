module RubyMotionQuery
  class RMQ
    # @return [Color]
    def self.color
      Color
    end

    # @return [Color]
    def color 
      Color
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

      # Creates a color from a hex triplet
      #
      # Thanks bubblewrap for this method
      #
      # @param hex with or without the #
      # @return [UIColor]
      # @example
      #   color.from_hex('#ffffff')
      #   color.from_hex('ffffff')
      def from_hex(hex_color)
        hex_color.gsub!("#", "")   
        case hex_color.size 
          when 3
            colors = hex_color.scan(%r{[0-9A-Fa-f]}).map{ |el| (el * 2).to_i(16) }
          when 6
            colors = hex_color.scan(%r<[0-9A-Fa-f]{2}>).map{ |el| el.to_i(16) }        
          else
            raise ArgumentError
        end 
        if colors.size == 3
          from_rgba(colors[0], colors[1], colors[2], 1.0)
        else
          raise ArgumentError
        end 
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
    end

  end

end
