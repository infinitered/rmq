module RubyMotionQuery
  class RMQ
    # @return [Font]
    def self.font
      Font
    end

    # @return [Font]
    def font
      Font
    end
  end

  class Font
    class << self

      # @example
      #   # One way to add your own fonts it to open up the Font class and add your own
      #   STANDARD_FONT = 'Helvetica Neue'
      #   def standard_at_size(size);
      #     UIFont.fontWithName(STANDARD_NAME, size: size)
      #   end
      #   def standard_large ; @standard_large ||= standard_at_size(18) ; end
      #   def standard_medium ; @standard_medium ||= standard_at_size(12) ; end
      #
      #
      #   # Another way is to add named fonts:
      #   RubyMotionQuery::Font.add_named_font :large,  STANDARD_FONT, 44
      #
      #   # In a stylesheet you can just do
      #   font.add_named_font :large,  STANDARD_FONT, 44
      #
      #   # The use like so in your stylesheet:
      #   font = font.large
      #
      #   # The use like so anywhere else:
      #   font = rmq.font.large
      def add_named(key, font_name_or_font, size = nil)
        font = if font_name_or_font.is_a?(UIFont)
          font_name_or_font
        else
          Font.font_with_name(font_name_or_font, size || 22)
        end

        Font.define_singleton_method(key) do
          font
        end
      end

      # @param name [String] Name of font
      # @param size [Float] Size of font
      # @return [UIFont]
      #
      # @example
      #   font = rmq.font.font_with_name('Helvetica Neue', 18)
      def font_with_name(name, size)
        # TODO, should rename this to just with_name, so it's rmq.font.with_name
        UIFont.fontWithName(name, size: size)
      end
      alias :with_name :font_with_name

      # Use this in the console to get a list of font families
      # @return [Array]
      def family_list
        UIFont.familyNames.sort
      end
      alias :family_names :family_list

      # @return [Array]
      def for_family(family)
        UIFont.fontNamesForFamilyName(family)
      end

      # @param size (Float)
      # @return [UIFont] System font given size
      #
      # @example
      #   font = rmq.font.system(18)
      def system(size = nil)
        UIFont.systemFontOfSize(size)
      end

    end
  end

end
