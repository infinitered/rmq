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

      # @return [UIApplicationDelegate]
      def delegate 
        UIApplication.sharedApplication.delegate
      end

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

      # Returns the current view controller in the app. If the current controller is a tab or
      # navigation controller, then it gets the current tab or topmost controller in the nav.
      #
      # This mostly works... mostly. As there really isn't a "current view_controller"
      #
      # @return [UIViewController]
      def current_view_controller(root_view_controller = nil)
        if root_view_controller || ((window = RMQ.app.window) && (root_view_controller = window.rootViewController))
          case root_view_controller
          when UINavigationController
            root_view_controller.visibleViewController
          when UITabBarController
            current_view_controller(root_view_controller.selectedViewController)
          else 
            root_view_controller
          end
        end
      end

    end
  end
end
