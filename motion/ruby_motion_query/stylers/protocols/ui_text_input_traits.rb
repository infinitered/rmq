module RubyMotionQuery
  module Stylers
    module Protocols

      # UITExtInputTraits protocol
      module UITextInputTraits
        def autocapitalization_type ; view.autocapitalizationType ; end
        def autocapitalization_type=(v) ; view.autocapitalizationType = v ; end

        def autocorrection_type ; view.autocorrectionType ; end
        def autocorrection_type=(v) ; view.autocorrectionType = v ; end

        def enables_return_key_automatically ; view.enablesReturnKeyAutomatically ; end
        def enables_return_key_automatically=(v) ; view.enablesReturnKeyAutomatically = v ; end

        def keyboard_appearance ; view.keyboardAppearance ; end
        def keyboard_appearance=(v) ; view.keyboardAppearance = v ; end

        def keyboard_type ; view.keyboardType ; end
        def keyboard_type=(v) ; view.keyboardType = v ; end

        def return_key_type ; view.returnKeyType ; end
        def return_key_type=(v) ; view.returnKeyType = v ; end

        def secure_text_entry ; view.secureTextEntry ; end
        def secure_text_entry=(v) ; view.secureTextEntry = v ; end

        def spell_checking_type ; view.spellCheckingType ; end
        def spell_checking_type=(v) ; view.spellCheckingType = v ; end
      end
    end
  end
end
