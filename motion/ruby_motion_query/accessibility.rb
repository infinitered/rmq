module RubyMotionQuery
  class RMQ

    # @return [Accessibility]
    def self.accessibility
      Accessibility
    end

    # @return [Accessibility]
    def accessibility
      Accessibility
    end
  end

  class Accessibility
    def self.voiceover_running?
      UIAccessibilityIsVoiceOverRunning()
    end
  end
end
