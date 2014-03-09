module RubyMotionQuery
  module Stylers
    module Protocols

      # UITExtInputTraits protocol
      module UITextInputTraits
        extend DelegatableMethod

        delegate_method :autocapitalization_type
        delegate_method :autocorrection_type
        delegate_method :enables_return_key_automatically
        delegate_method :keyboard_appearance
        delegate_method :keyboard_type
        delegate_method :return_key_type
        delegate_method :secure_text_entry
        delegate_method :spell_checking_type
      end
    end
  end
end
