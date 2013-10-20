class <%= @name_camel_case %>Controller < UICollectionViewController
  # In app_delegate.rb or wherever you use this controller, just call #new like so:
  # @window.rootViewController =  <%= @name_camel_case %>Controller.new

  def self.new(args = {})
    # Set layout 
    layout = UICollectionViewFlowLayout.alloc.init
    self.alloc.initWithCollectionViewLayout(layout)
  end

  def viewDidLoad
    super

    rmq.stylesheet = <%= @name_camel_case %>ControllerStylesheet

    collectionView.tap do |cv|
      cv.registerClass(<%= @name_camel_case %>Cell, forCellWithReuseIdentifier: <%= @name_camel_case %>Cell.name)
      cv.delegate = self
      cv.dataSource = self
      cv.allowsSelection = true
      cv.allowsMultipleSelection = false
      rmq(cv).apply_style :collection_view
    end
  end

  # Remove if you are only supporting portrait
  def supportedInterfaceOrientations
    UIInterfaceOrientationMaskAll
  end

  # Remove if you are only supporting portrait
  def willAnimateRotationToInterfaceOrientation(orientation, duration: duration)
    rmq.all.reapply_styles
  end

  def numberOfSectionsInCollectionView(view)
    1
  end
 
  def collectionView(view, numberOfItemsInSection: section)
    40
  end
    
  def collectionView(view, cellForItemAtIndexPath: index_path)
    view.dequeueReusableCellWithReuseIdentifier(<%= @name_camel_case %>Cell.name, forIndexPath: index_path).tap do |cell|
      cell.setup_with(rmq)

      # Update cell's data here
    end
  end

  def collectionView(view, didSelectItemAtIndexPath: index_path)
    cell = collectionView.cellForItemAtIndexPath(index_path)
  end

end

__END__

# You don't have to reapply styles to all UIViews, if you want to optimize, 
# another way to do it is tag the views you need to restyle in your stylesheet, 
# then only reapply the tagged views, like so:
def logo(st)
  st.frame = {t: 10, w: 200, h: 96}
  st.centered = :horizontal
  st.image = image.resource('logo')
  st.tag(:reapply_style)
end

# Then in willAnimateRotationToInterfaceOrientation
rmq(:reapply_style).reapply_styles
