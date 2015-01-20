module RubyMotionQuery
  module Stylers
    class UIButtonStyler < UIControlStyler

      def text=(value)
        @view.setTitle(value, forState: UIControlStateNormal)
      end
      def text
        @view.title
      end

      def font=(value) ; @view.titleLabel.font = value ; end
      def font ; @view.titleLabel.font ; end

      def color=(value)
        @view.setTitleColor(value, forState: UIControlStateNormal)
      end
      def color
        @view.titleColor
      end

      def color_highlighted=(value)
        @view.setTitleColor(value, forState: UIControlStateHighlighted)
      end
      def color_highlighted
        @view.titleColorforState(UIControlStateHighlighted)
      end

      def tint_color=(value)
        @view.tintColor = value
      end
      def tint_color
        @view.tintColor
      end

      def image=(value)
        self.image_normal = value
      end
      def image_normal=(value)
        @view.setImage value, forState: UIControlStateNormal
      end

      def image_highlighted=(value)
        @view.setImage value, forState: UIControlStateHighlighted
      end

      def background_image_normal=(value)
        @view.setBackgroundImage value, forState: UIControlStateNormal
      end

      def background_image_highlighted=(value)
        @view.setBackgroundImage value, forState: UIControlStateHighlighted
      end

      # Accepts UIEdgeInsetsMake OR and array of values to be the inset.
      # st.title_edge_insets = UIEdgeInsetsMake(0, 10.0, 0, 0)
      # OR
      # st.title_edge_insets = [0, 10.0, 0, 0]
      def title_edge_insets=(value)
        value = UIEdgeInsetsMake(value[0], value[1], value[2], value[3]) if value.is_a? Array
        @view.setTitleEdgeInsets(value)
      end

      def title_edge_insets
        @view.titleEdgeInsets
      end

      # Accepts UIEdgeInsetsMake OR and array of values to be the inset.
      # st.image_edge_insets = UIEdgeInsetsMake(0, 10.0, 0, 0)
      # OR
      # st.image_edge_insets = [0, 10.0, 0, 0]
      def image_edge_insets=(value)
        value = UIEdgeInsetsMake(value[0], value[1], value[2], value[3]) if value.is_a? Array
        @view.setImageEdgeInsets(value)
      end

      def image_edge_insets
        @view.imageEdgeInsets
      end

      def text_highlighted value
        @view.setTitle(value, forState:UIControlStateHighlighted)
      end

      def text_highlighted= value
        @view.setTitle(value, forState:UIControlStateHighlighted)
      end

    end
  end
end
