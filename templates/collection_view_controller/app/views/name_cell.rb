class <%= @name_camel_case %>Cell < UICollectionViewCell 
  def setup_with(controller_rmq)
    unless @initialized
      @initialized = true

      controller_rmq.wrap(self).tap do |q|
        q.apply_style :<%= @name %>_cell

        # Add your subviews, init stuff here
        # @foo = q.append(UILabel, :foo).get
      end
    end
  end

  def prepareForReuse
  end
end
