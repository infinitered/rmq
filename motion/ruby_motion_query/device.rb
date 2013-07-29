module RubyMotionQuery
  class RMQ
    def device
      Device
    end
    def self.device
      Device
    end
  end

  class Device
    class << self
      def screen
        UIScreen.mainScreen
      end

      def width
        @_width ||= Device.screen.bounds.size.width
      end

      def height
        @_height ||= Device.screen.bounds.size.height
      end

      def ipad?
        @_ipad = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPad) if @_ipad.nil?
        @_ipad
      end

      def iphone?
        @_iphone = (UIDevice.currentDevice.userInterfaceIdiom == UIUserInterfaceIdiomPhone) if @_iphone.nil?
        @_iphone
      end

      def four_inch?
        @_four_inch = (Device.height == 568.0) if @_four_inch.nil?
        @_four_inch
      end

      def retina?()
        if @_retina.nil?
          main_screen = Device.screen
          @_retina = !!(main_screen.respondsToSelector('displayLinkWithTarget:selector:') && main_screen.scale == 2.0)
        end

        @_retina
      end

      def orientation
        ORIENTATIONS[UIDevice.currentDevice.orientation] || :unknown
      end

      def landscape?
        Device.orientation == :landscape_Left || Device.orientation == :landscape_right
      end

      def portrait?
        Device.orientation == :portrait || Device.orientation == :unknown
      end

      ORIENTATIONS = { 
        UIDeviceOrientationUnknown => :unkown,
        UIDeviceOrientationPortrait => :portrait,
        UIDeviceOrientationPortraitUpsideDown => :portrait_upside_down,
        UIDeviceOrientationLandscapeLeft => :landscape_Left,
        UIDeviceOrientationLandscapeRight => :landscape_right,
        UIDeviceOrientationFaceUp => :face_up, 
        UIDeviceOrientationFaceDown => :face_down
      }

    end
  end
end
