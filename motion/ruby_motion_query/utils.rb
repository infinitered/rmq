module RubyMotionQuery
  class RMQ
    class << self
      # @return [Boolean]
      def is_class?(o)
        o.class == Class
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

      # Converts any string to a friendly symbol version.
      # Example:  RubyMotionQuery::RMQ.symbolize("This is a TEST!!")
      # #=> :this_is_a_test
      #
      # @param [String]
      # @return [Symbol]
      def symbolize(s)
        s.to_s.gsub(/\s+/,"_").gsub(/\W+/,"").downcase.to_sym
      end

      # @param view
      # @return [UIViewController] The controller the view it is sitting in, or nil if it's not sitting anywhere in particular
      def controller_for_view(view)
        #debug.assert(view.nil? || view.is_a?(UIView), 'Invalid view in controller for view', {view: view})

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
      # Creating a WeakRef with a literal like a string will cause your app to crash
      # instantly, it's fun, try it. Only create weak refs of variables
      #
      # @example
      # foo = RubyMotionQuery::RMQ.weak_ref(bar)
      def weak_ref(o)
        if is_object_weak_ref?(o)
          o
        else
          WeakRef.new(o)
        end
      end

      # Gets a strong reference from a weak reference
      def weak_ref_to_strong_ref(weak_ref)
        weak_ref.tap{} # This is a hack but it works, is there a better way?
      end

      # Is an object a weak_ref
      def is_object_weak_ref?(o)
        o.respond_to?(:weakref_alive?) # This is the only way to do this currently
      end

      # Gives you the value of a weakref, if the object it wraps no longer exists, returns nil
      def weak_ref_value(o)
        if o && o.weakref_alive?
          o
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

