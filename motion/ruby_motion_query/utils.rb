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

      # @deprecated this is no longer needed in RubyMotion >= 2.19. In a later version this will be
      # changed to simply be a wrapper of RubyMotion's WeakRef
      #
      #
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
        weak = WeakRef.new(weak_ref_to_strong_ref(o))
        #WeakRef.new(o) # For future release
      end

      # @deprecated this has been fixed in RubyMotion 2.17, so this method is no longer needed.
      #
      # This gets around a bug in RubyMotion
      # Hopefully I can remove this quickly. Only use this for complex objects that have no comparison
      # other than that they are the exact same object. For example, strings compare their contents.
      def weak_ref_is_same_object?(a, b)
        (a.class == b.class) && (a.object_id == b.object_id)
        #a == b # For future release
      end

      # Gets a strong reference from a weak reference
      def weak_ref_to_strong_ref(weak_ref)
        # This is a hack but it works, is there a better way?
        weak_ref.tap{}
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

