describe 'tags' do
  before do
    @vc = UIViewController.alloc.init
    @root_view = @vc.view
  end

  it 'should tag a view with a single tag' do
    @vc.rmq.append(UIView).tap do |q|
      q.tag(:foo)
      q.get.rmq_data.tags.should.include :foo
      q.get.rmq_data.tags.should.not.include :bar
    end
  end

  it 'should tag a view with a multiple tags' do
    @vc.rmq.append(UIView).tap do |q|
      q.tag(:foo, :bar)
      q.get.rmq_data.tags.should.include :foo
      q.get.rmq_data.tags.should.include :bar
    end
  end

  it 'should return tag names from rmq_data' do
    @vc.rmq.append(UIView).tap do |q|
      q.tag(:foo, :bar)
      q.get.rmq_data.tag_names.sort.should == [:bar, :foo]
      q.get.rmq_data.tag_names.should.not.include :tree
    end
  end

end
