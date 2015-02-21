module RubyMotionQuery
  module Stylers
    module Protocols

      # UITExtInputTraits protocol
      module UITextInputTraits
        def autocapitalization_type ; view.autocapitalizationType ; end
        def autocapitalization_type=(v) ; view.autocapitalizationType = AUTO_CAPITALIZATION_TYPES[v] || v ; end

        def autocorrection_type ; view.autocorrectionType ; end
        def autocorrection_type=(v) ; view.autocorrectionType = AUTO_CORRECTION_TYPES[v] || v ; end

        def enables_return_key_automatically ; view.enablesReturnKeyAutomatically ; end
        def enables_return_key_automatically=(v) ; view.enablesReturnKeyAutomatically = v ; end

        def keyboard_appearance ; view.keyboardAppearance ; end
        def keyboard_appearance=(v) ; view.keyboardAppearance = KEYBOARD_APPEARANCES[v] || v ; end

        def keyboard_type ; view.keyboardType ; end
        def keyboard_type=(v) ; view.setKeyboardType(KEYBOARD_TYPES[v] || v) ; end

        def return_key_type ; view.returnKeyType ; end
        def return_key_type=(v) ; view.setReturnKeyType(RETURN_KEY_TYPES[v] || v) ; end

        def secure_text_entry ; view.secureTextEntry ; end
        def secure_text_entry=(v) ; view.secureTextEntry = v ; end

        def spell_checking_type ; view.spellCheckingType ; end
        def spell_checking_type=(v) ; view.setSpellCheckingType(SPELL_CHECKING_TYPES[v] || v) ; end
      end
    end
  end
end
