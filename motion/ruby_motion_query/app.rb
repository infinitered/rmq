module RubyMotionQuery
  class RMQ
    def app
      App
    end

    def self.app
      App
    end
  end

  class App
    class << self

      def window
        UIApplication.sharedApplication.keyWindow || UIApplication.sharedApplication.windows[0]
      end

      def delegate 
        UIApplication.sharedApplication.delegate
      end

      def environment
        RUBYMOTION_ENV.to_sym
      end

      def release?
        environment == :release
      end
      alias :production? :release?

      def test?
        environment == :test
      end

      def development?
        environment == :development
      end

      def version
        NSBundle.mainBundle.infoDictionary['CFBundleVersion']
      end

      def name
        NSBundle.mainBundle.objectForInfoDictionaryKey 'CFBundleDisplayName'
      end

      def identifier
        NSBundle.mainBundle.bundleIdentifier
      end

      def resource_path
        NSBundle.mainBundle.resourcePath
      end

      def document_path
        NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
      end
    end
  end
end
