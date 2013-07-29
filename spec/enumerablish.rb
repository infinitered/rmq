describe 'enumerablish' do
  before do
    @view_controller = UIViewController.alloc.init
    @rmq = @view_controller.rmq

    @view0 = UIView.alloc.initWithFrame(CGRectZero)
    @view1 = UIImageView.alloc.initWithFrame(CGRectZero)
    @view2 = UIView.alloc.initWithFrame(CGRectZero)
    @view3 = UIView.alloc.initWithFrame(CGRectZero)
    @view4 = UIView.alloc.initWithFrame(CGRectZero)

    @view_controller.view.tap do |o|
      o.addSubview(@view0)
      o.addSubview(@view1)
      o.addSubview(@view2)
    end

    @view3.addSubview(@view4)
    @view1.addSubview(@view3)
  end

  it 'should return an array with to_a' do
    @rmq.find.to_a.is_a?(Array).should == true
  end

  it 'should return an RMQ instance when #each is called' do
    ret = @rmq.each{|o|}  
    ret.is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should return an RMQ instance when #map is called' do
    ret = @rmq.map
    ret.is_a?(RubyMotionQuery::RMQ).should == true

    ret = @rmq.map{|o| o}
    ret.is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'length should return count of views in set' do
    @rmq.find.length.should == 5
    @rmq.find.size.should == 5
    @rmq.find.count.should == 5
  end

  it 'should concantinate a UIView (only a UIView) onto the end of the existing set' do
    all = @rmq.find
    all.length.should == 5

    @view5 = UIView.alloc.initWithFrame([[0,0],[10,10]])
    all << @view5 
    all.length.should == 6
    all.to_a[all.length - 1].should == @view5

    all << 'Will not add'
    all.length.should == 6
    all.to_a[all.length - 1].should == @view5

    all << nil
    all.length.should == 6
    all.to_a[all.length - 1].should == @view5
  end

  # TODO, lots more tests

end
