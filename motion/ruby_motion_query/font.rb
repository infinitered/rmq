# Add custome app-wide fonts here
module RubyMotionQuery
  class RMQ
    def self.font
      Font
    end

    def font
      Font
    end
  end

  class Font
    class << self
      # One way to add your own fonts it to open up the Font class and add your
      # own message.
      #
      # STANDARD_FONT = 'Helvetica Neue'
      # def standard_at_size(size);
      #   UIFont.fontWithName(STANDARD_NAME, size: size)
      # end
      # def standard_large ; @standard_large ||= standard_at_size(18) ; end
      # def standard_medium ; @standard_medium ||= standard_at_size(12) ; end

      
      # Another way is to add named fonts:
      #
      # Example
      #   RubyMotionQuery::Font.add_named_font :large,  STANDARD_FONT, 44
      #
      #   # The use like so in your stylesheet:
      #     font = font.large
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

      def font_with_name(name, size)
        UIFont.fontWithName(name, size: size)
      end
      alias :with_name :font_with_name

      # Use this in the console to get a list of font families
      def family_list
        UIFont.familyNames.sort
      end

      def for_family(family)
        UIFont.fontNamesForFamilyName(family)
      end

      def system(size = nil)
        UIFont.systemFontOfSize(size)
      end

    end
  end

end
