module RubyMotionQuery
  class RMQ
    # @return [App]
    def app
      App
    end

    # @return [App]
    def self.app
      App
    end
  end

  class App
    class << self

      # @return [UIWindow]
      def window
        if shared_application = UIApplication.sharedApplication
          shared_application.keyWindow || shared_application.windows[0]
        end
      end

      def windows
        if shared_application = UIApplication.sharedApplication
          shared_application.windows
        end
      end

      # @return [UIApplicationDelegate]
      def delegate
        UIApplication.sharedApplication.delegate
      end

      # @return [UIApplication]
      def get
        UIApplication.sharedApplication
      end

      # Returns boolean of success of hiding
      # Tested in the example app!
      # @return [Boolean]
      def hide_keyboard
        self.get.sendAction(:resignFirstResponder, to:nil, from:nil, forEvent:nil)
      end
      alias :resign_responders :hide_keyboard
      alias :end_editing :hide_keyboard

      # @return [Symbol] Environment the app is running it
      def environment
        @_environment ||= RUBYMOTION_ENV.to_sym
      end

      # @return [Boolean] true if the app is running in the :release environment
      def release?
        environment == :release
      end
      alias :production? :release?

      # @return [Boolean] true if the app is running in the :test environment
      def test?
        environment == :test
      end

      # @return [Boolean] true if the app is running in the :development environment
      def development?
        environment == :development
      end

      # @return [String] Version
      def version
        NSBundle.mainBundle.infoDictionary['CFBundleVersion']
      end

      # @return [String] Short version
      def short_version
        NSBundle.mainBundle.infoDictionary['CFBundleShortVersionString']
      end

      # @return [String] Name of app
      def name
        NSBundle.mainBundle.objectForInfoDictionaryKey 'CFBundleDisplayName'
      end

      # @return [String] Identifier of app
      def identifier
        NSBundle.mainBundle.bundleIdentifier
      end

      # @return [String] Full path of the resources folder
      def resource_path
        NSBundle.mainBundle.resourcePath
      end

      # @return [String] Full path of the document folder
      def document_path
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
      end

      # @return [NSTimer] NSTimer instance, fires once after <seconds>
      def after(seconds, &callback)
        NSTimer.scheduledTimerWithTimeInterval(seconds, target: callback, selector: 'call:', userInfo: nil, repeats: false)
      end
      alias delay after

      # @return [NSTimer] NSTimer instance, set to repeat every <seconds>
      def every(seconds, &callback)
        NSTimer.scheduledTimerWithTimeInterval(seconds, target: callback, selector: 'call:', userInfo: nil, repeats: true)
      end

      # Returns the current view controller in the app. If the current controller is a tab or
      # navigation controller, then it gets the current tab or topmost controller in the nav, etc
      #
      # This mostly works... mostly. As there really isn't a "current view_controller"
      #
      # @return [UIViewController]
      def current_view_controller(root_view_controller = nil)
        if root_view_controller || ((window = RMQ.app.window) && (root_view_controller = window.rootViewController))
          case root_view_controller
          when UINavigationController
            current_view_controller(root_view_controller.visibleViewController)
          when UITabBarController
            current_view_controller(root_view_controller.selectedViewController)
          else
            if root_view_controller.respond_to?(:visibleViewController)
              current_view_controller(root_view_controller.visibleViewController)
            elsif root_view_controller.respond_to?(:topViewController)
              current_view_controller(root_view_controller.topViewController)
            elsif root_view_controller.respond_to?(:frontViewController)
              current_view_controller(root_view_controller.frontViewController)
            elsif root_view_controller.respond_to?(:center) && (center = root_view_controller.center) && center.is_a?(UIViewController)
              current_view_controller(root_view_controller.center)
            elsif root_view_controller.respond_to?(:childViewControllers) && root_view_controller.childViewControllers.count > 0
              current_view_controller(root_view_controller.childViewControllers.first)
            else
              root_view_controller
            end
          end
        end
      end

    end
  end
end
