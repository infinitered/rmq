module RubyMotionQuery
  class RMQ
    # @return [ImageUtils]
    def self.image
      ImageUtils
    end

    # @return [ImageUtils]
    def image
      ImageUtils
    end
  end

  class ImageUtils
    class << self
      DEFAULT_IMAGE_EXT = 'png'

      # @return [UIImage]
      def resource_for_device(file_base_name, opts = {})
        resource( RMQ.device.four_inch? ? "#{file_base_name}-568h" : file_base_name, opts)
      end

      # @return [UIImage]
      def resource(file_base_name, opts = {})
        ext = opts[:ext] || DEFAULT_IMAGE_EXT
        cached = opts[:cached]
        cached = true if cached.nil?

        if cached
          UIImage.imageNamed("#{file_base_name}.#{ext}") 
        else
          file_base_name << '@2x' if RMQ.device.retina?
          file = NSBundle.mainBundle.pathForResource(file_base_name, ofType: ext)
          UIImage.imageWithContentsOfFile(file)
        end
      end

      # @example
      #   image = rmq.image.resource_resizable('foo', top: 4, left: 4, right: 4, bottom: 4)
      # or in styler
      #   st.image = image.resource_resizable('foo', top: 4, left: 4, right: 4, bottom: 4)
      #
      # @return [UIImage]
      def resource_resizable(file_base_name, opts)
        # TODO, also alloow short syntax, t: instead of top: etc
        ext = opts[:ext] || DEFAULT_IMAGE_EXT
        image = resource(file_base_name, opts)
        image.resizableImageWithCapInsets([opts[:top], opts[:left], opts[:bottom], opts[:right]], resizingMode: UIImageResizingModeStretch) 
      end

      # Note: FROM Sugarcube, thanks Sugarcube
      #
      # Easily take a snapshot of a `UIView`.
      #
      # Calling `from_view` with no arguments will return the image based on the
      # `bounds` of the image.  In the case of container views (notably
      # `UIScrollView` and its children) this does not include the entire contents,
      # which is something you probably want.
      #
      # If you pass a truthy value to this method, it will use the `contentSize` of
      # the view instead of the `bounds`, and it will draw all the child views, not
      # just those that are visible in the viewport.
      #
      # It is guaranteed that `true` and `:all` will always have this behavior.  In
      # the future, if this argument becomes something that accepts multiple values,
      # those two are sacred.
      #
      # @return [UIImage]
      def from_view(view, use_content_size = false)
        scale = UIScreen.mainScreen.scale
        if use_content_size
          UIGraphicsBeginImageContextWithOptions(view.contentSize, false, scale)
          graphics_context = UIGraphicsGetCurrentContext()
          view.subviews.each do |subview|
            CGContextSaveGState(graphics_context)
            CGContextTranslateCTM(graphics_context, subview.frame.origin.x, subview.frame.origin.y)
            subview.layer.renderInContext(graphics_context)
            CGContextRestoreGState(graphics_context)
          end
          image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
        else
          UIGraphicsBeginImageContextWithOptions(view.bounds.size, false, scale)
          view.layer.renderInContext(UIGraphicsGetCurrentContext())
          image = UIGraphicsGetImageFromCurrentImageContext()
          UIGraphicsEndImageContext()
        end
        image
      end
    end
  end
end
