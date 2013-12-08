module RubyMotionQuery
  class RMQ

    class << self
      # @return [Boolean]
      def is_class?(o)
        # This line fails in spec, causes exit without message. It works fine in production
        #(o.class == Class) && (defined?(o) == 'constant')
        
        # So I'm doing this instead
        !!(o.respond_to?(:name) && o.name.to_s[0] =~ /[A-Z]/)
      end

      # This is purposely not blank? as to not conflict with many libraries that
      # add .blank? to Object
      #
      # @return [Boolean]
      def is_blank?(o)
        if o.is_a?(RubyMotionQuery::RMQ)
          RubyMotionQuery::RMQ.is_blank?(o.to_a)
        else
          o.respond_to?(:empty?) ? o.empty? : !o
        end
      end

      # @param view
      # @return [UIViewController] The controller the view it is sitting in, or nil if it's not sitting anywhere in particular 
      def controller_for_view(view)
        if view && (vc = view.rmq_data.view_controller)
          vc 
        else

          # Non-recursive for speed
          while view
            view = view.nextResponder
            if view.is_a?(UIViewController)
              break
            elsif view.is_a?(UIView)
              if vc = view.rmq_data.view_controller
                view = vc
                break
              end
            else
              view = nil
            end
          end

          view

        end
      end

      # Creates a weak reference to an object. Unlike WeakRef.new provided by RubyMotion, this will 
      # not wrap a weak ref inside another weak ref (which causes bugs).
      #
      # This is fairly performant. It's about twice as slow as WeakRef.new. However, you can 
      # create a million weak refs in about 651 miliseconds, compared to 319 for WeakRef.new
      #
      # Creating a WeakRef with a literal like a string will cause your app to crash
      # instantly, it's fun, try it. Only create weak refs of variables
      #
      # @example
      # foo = RubyMotionQuery::RMQ.weak_ref(bar)
      def weak_ref(o)
        weak = WeakRef.new(o)
        if weak.is_a?(WeakRef)
          o # Already a weak ref, return original
        else
          weak
        end
      end

      # Mainly used for console and logging
      #
      # @return [String]
      def view_to_s(view)
        out = "\n"
        out << "  VIEW  class:o #{view.class.name}  object_id: #{view.object_id}\n"
        out << "    RECTANGLE  left: #{view.origin.y}, top: #{view.origin.y}, width: #{view.size.width}, height: #{view.size.height}\n"
        out << "    SUPERVIEW  class: #{view.superview.class.name}  object_id: #{view.superview.object_id} \n" if view.superview
        out << "    SUBVIEWS   count: #{view.subviews.length}\n"
        out
      end
    end

  end
end

