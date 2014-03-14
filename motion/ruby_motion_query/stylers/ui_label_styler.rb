module RubyMotionQuery
  module Stylers

    class UILabelStyler < UIViewStyler
      def text=(value) ; @view.setText value ; end
      def text ; @view.text ; end

      def font=(value) ; @view.setFont value ; end
      def font ; @view.font ; end

      def color=(value) ; @view.setTextColor value ; end
      def color ; @view.textColor ; end

      def number_of_lines=(value)
        value = 0 if value == :unlimited
        @view.setNumberOfLines(value)
      end
      def number_of_lines
        if @view.numberOfLines == 0
          :unlimited
        else
          @view.numberOfLines
        end
      end

      def text_alignment=(value)
        @view.setTextAlignment(TEXT_ALIGNMENTS[value] || value)
      end
      def text_alignment
        @view.textAlignment
      end

      def resize_to_fit_text
        @view.sizeToFit
      end
      alias :size_to_fit :resize_to_fit_text

      def adjusts_font_size=(value)
        # Adhere to Apple documentation recommendations:
        number_of_lines = 1 if value == true

        @view.adjustsFontSizeToFitWidth = value
      end
      def adjusts_font_size
        @view.adjustsFontSizeToFitWidth
      end
    end

  end
end
