describe 'image' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'should return image from RMQ or an instance of rmq' do
    @rmq.image.should == RubyMotionQuery::ImageUtils

    rmq = RubyMotionQuery::RMQ.new
    rmq.image.should == RubyMotionQuery::ImageUtils
  end

  it "should convert a view to a UIImage" do
    view = UIView.alloc.initWithFrame([[0, 0], [10, 10]])
    image = @rmq.image.from_view(view)
    image.class.should == UIImage
    CGSizeEqualToSize(image.size, [10, 10]).should == true
    image.scale.should == UIScreen.mainScreen.scale
  end

  # TODO test resource with and without caching, resource_for_device, and resource_resizable
end
