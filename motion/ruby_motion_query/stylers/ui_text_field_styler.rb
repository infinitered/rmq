module RubyMotionQuery
  module Stylers
    class UITextFieldStyler < UIControlStyler
      include Protocols::UITextInputTraits

      # Accessing the Text Attributes
      delegate_method :text
      delegate_method :attributed_text
      delegate_method :placeholder
      delegate_method :attributed_placeholder
      delegate_method :default_text_attributes
      delegate_method :font
      delegate_method :text_color
      delegate_method :text_alignment
      delegate_method :typing_attributes

      # Sizing the Text Field's Text
      delegate_method :adjusts_font_size_to_fit_width
      delegate_method :minimum_font_size

      # Managing the Eiting Behavior
      delegate_method :editing
      delegate_method :clears_on_begin_editing
      delegate_method :clears_on_insertion
      delegate_method :allows_editing_text_attributes

      # Setting the View's Background Appearance
      delegate_method :border_style
      delegate_method :background
      delegate_method :disabled_background

      # managing overlay views
      delegate_method :clear_button_mode
      delegate_method :left_view
      delegate_method :left_view_mode
      delegate_method :right_view
      delegate_method :right_view_mode
    end
  end
end
