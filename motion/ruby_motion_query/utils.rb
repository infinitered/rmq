module RubyMotionQuery
  class RMQ

    class << self
      def is_class?(o)
        # This line fails in spec, causes exit without message. It works fine in production
        #(o.class == Class) && (defined?(o) == 'constant')
        
        # So I'm doing this instead
        !!(o.respond_to?(:name) && o.name.to_s[0] =~ /[A-Z]/)
      end

      # This is purposely not blank? as to not conflict with many libraries that
      # add .blank? to Object
      def is_blank?(o)
        if o.is_a?(RubyMotionQuery::RMQ)
          RubyMotionQuery::RMQ.is_blank?(o.to_a)
        else
          o.respond_to?(:empty?) ? o.empty? : !o
        end
      end

 
      # Given a UIView, returns the UIViewController it is sitting in, or nil if it's not
      # sitting anywhere in particular 
      def controller_for_view(view)
        # Non-recursive for speed
        while view
          view = view.nextResponder
          if view.is_a?(UIViewController)
            break
          elsif !view.is_a?(UIView)
            view = nil
          end
        end

        view
      end

      # Mainly used for console and logging
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

