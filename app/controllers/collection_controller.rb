class CollectionController < UICollectionViewController
  COLLECTION_CELL_ID = "CollectionCell"
  
  def self.new(args = {})
    # Set layout 
    layout = UICollectionViewFlowLayout.alloc.init
    self.alloc.initWithCollectionViewLayout(layout)
  end

  def viewDidLoad
    super

    self.title = 'Collection View'

    rmq.stylesheet = CollectionControllerStylesheet

    collectionView.tap do |cv|
      cv.registerClass(CollectionCell, forCellWithReuseIdentifier: COLLECTION_CELL_ID)
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
    rmq(:reapply_style).reapply_styles
  end

  def numberOfSectionsInCollectionView(view)
    1
  end
 
  def collectionView(view, numberOfItemsInSection: section)
    200 
  end
    
  def collectionView(view, cellForItemAtIndexPath: index_path)
    view.dequeueReusableCellWithReuseIdentifier(COLLECTION_CELL_ID, forIndexPath: index_path).tap do |cell|
      rmq.build(cell) unless cell.reused

      # Update cell's data here
    end
  end

  def collectionView(view, didSelectItemAtIndexPath: index_path)
    cell = view.cellForItemAtIndexPath(index_path)
    puts "Selected at section: #{index_path.section}, row: #{index_path.row}"
  end

end
