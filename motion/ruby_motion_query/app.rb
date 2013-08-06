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
        UIApplication.sharedApplication.keyWindow || UIApplication.sharedApplication.windows[0]
      end

      # @return [UIApplicationDelegate]
      def delegate 
        UIApplication.sharedApplication.delegate
      end

      # @return [Symbol] Environment the app is running it
      def environment
        RUBYMOTION_ENV.to_sym
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
    end
  end
end
