class <%= @name_camel_case %>ControllerStylesheet < ApplicationStylesheet

  include <%= @name_camel_case %>CellStylesheet

  def setup
    # Add sytlesheet specific setup stuff here.
    # Add application specific setup stuff in application_stylesheet.rb

    @margin = ipad? ? 12 : 8
  end

  def collection_view(st)
    st.view.contentInset = [@margin, @margin, @margin, @margin]
    st.background_color = color.white

    st.view.collectionViewLayout.tap do |cl|
      cl.itemSize = cell_size
      #cl.scrollDirection = UICollectionViewScrollDirectionHorizontal
      #cl.headerReferenceSize = cell_size
      cl.minimumInteritemSpacing = @margin 
      cl.minimumLineSpacing = @margin 
      #cl.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight,
      #cl.sectionInsert = [0,0,0,0]
    end
  end
end
