module RubyMotionQuery
  module Stylers
    class UITextViewStyler < UIScrollViewStyler
      include Protocols::UITextInputTraits

      def text ; view.text ; end
      def text=(v) ; view.text = v ; end

      def attributed_text ; view.attributedText ; end
      def attributed_text=(v) ; view.attributedText = v ; end

      def editable ; view.isEditable ; end
      def editable=(v) ; view.editable = !!v ; end

      def selectable ; view.isSelectable ; end
      def selectable=(v) ; view.selectable = !!v ; end

      def data_detector_types ; view.dataDetectorTypes ; end
      def data_detector_types=(v) ; view.dataDetectorTypes = (DETECTOR_TYPES[v] || v) ; end

      def font ; view.font ; end
      def font=(v) ; view.font = v ; end

      def text_alignment ; view.textAlignment ; end
      def text_alignment=(v) ; view.textAlignment = TEXT_ALIGNMENTS[v] || v ; end

      def text_color ; view.textColor ; end
      def text_color=(v) ; view.textColor = v ; end
      alias :color :text_color
      alias :color= :text_color=

      DETECTOR_TYPES = {
        phone:    UIDataDetectorTypePhoneNumber,
        link:     UIDataDetectorTypeLink,
        addresss: UIDataDetectorTypeAddress,
        event:    UIDataDetectorTypeCalendarEvent,
        none:     UIDataDetectorTypeNone,
        all:      UIDataDetectorTypeAll
      }

    end
  end
end
