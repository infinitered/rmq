class CollectionCell < UICollectionViewCell 
  attr_reader :reused

  def rmq_build
    rmq(self).apply_style :collection_cell

    rmq(self.contentView).tap do |q|
      q.append(UILabel, :title).get.text = rand(100).to_s
    end
  end

  def prepareForReuse
    @reused = true
  end
end
