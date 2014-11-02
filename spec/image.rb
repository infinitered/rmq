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

  describe "resource_resizable" do
    it "should return an image with the proper cap insets" do
      opts = { top: 1, left: 1, bottom: 1, right: 1 }
      image = @rmq.image.resource_resizable('logo', opts)

      image.is_a?(UIImage).should.be.true
      image.capInsets.should == UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)
    end

    it "should accept the shortcut labels for position as well" do
      opts = { t: 1, l: 1, b: 1, r: 1 }
      image = @rmq.image.resource_resizable('logo', opts)

      image.is_a?(UIImage).should.be.true
      image.capInsets.should == UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0)
    end
  end

  # TODO test resource with and without caching, resource_for_device
end
