describe 'tags' do
  before do
    @vc = UIViewController.alloc.init
    @root_view = @vc.view
  end

  it 'should tag and untag a view with a single tag' do
    @vc.rmq.append(UIView).tap do |q|
      q.tag(:foo)
      q.get.rmq_data.tags.should.include :foo
      q.get.rmq_data.tags.should.not.include :bar
      q.untag(:foo)
      q.get.rmq_data.tags.should.not.include :foo
    end
  end

  it 'should tag and untag a view with a multiple tags' do
    @vc.rmq.append(UIView).tap do |q|
      q.tag(:foo, :bar)
      q.get.rmq_data.tags.should.include :foo
      q.get.rmq_data.tags.should.include :bar
      q.untag(:foo, :bar)
      q.get.rmq_data.tags.should.not.include :foo
      q.get.rmq_data.tags.should.not.include :bar
    end
  end

  it 'should only untag if tag exists' do
    @vc.rmq.append(UIView).tap do |q|
      q.tag(:foo)
      q.untag(:bar)
      q.untag(:bar, :baz)
      q.untag
      q.get.rmq_data.tag_names.should == [:foo]
    end
  end

  it 'should return tag names from rmq_data' do
    @vc.rmq.append(UIView).tap do |q|
      q.tag(:foo, :bar)
      q.get.rmq_data.tag_names.sort.should == [:bar, :foo]
      q.get.rmq_data.tag_names.should.not.include :tree
    end
  end

  it 'should clear all tags' do
    @vc.rmq.append(UIView).tap do |q|
      q.tag(:foo, :bar)
      q.get.rmq_data.tag_names.sort.should == [:bar, :foo]
      q.clear_tags.is_a?(RubyMotionQuery::RMQ).should == true
      q.get.rmq_data.tag_names.should == []
    end
  end

  it 'should allow a hash to be sent to tag, assignign the values' do
    @vc.rmq.append(UIView).tap do |q|
      q.tag(one: 2)
      q.get.rmq_data.tags.should.include :one
      q.get.rmq_data.tags.length.should == 1
      q.tag(foo: 66, bar: 'Hello')
      q.get.rmq_data.tags.length.should == 3
      q.get.rmq_data.tags.should.include :foo
      q.get.rmq_data.tags.should.include :bar
      q.get.rmq_data.tags[:foo].should == 66
      q.get.rmq_data.tags[:bar].should == 'Hello'
    end
  end

  it 'should be able to check for tags' do
    @vc.rmq.append(UIView).tap do |q|
      q.has_tag?(:test).should == false
      q.tag(:test)
      q.has_tag?(:test).should == true
    end
  end

  it 'should return the tags for the selection' do
    @vc.rmq.append(UIView).tag(data: "some-data")
    @vc.rmq.append(UIView).tag(other_data: "other-data")
    @vc.rmq.all.tags.should == { data: "some-data", other_data: "other-data" }
  end

  it 'should be able to return tag data' do
    @vc.rmq.append(UIView).tag(data: "some-data").tap do |q|
      q.tags(:data).should == "some-data"
    end
  end

  it 'should return an array of data if there are duplicate tags in the selection' do
    @vc.rmq.append(UIView).tag(data: "some-data")
    @vc.rmq.append(UIView).tag(data: "other-data")
    @vc.rmq.all.tags(:data).should == ["some-data", "other-data"]
  end

end
