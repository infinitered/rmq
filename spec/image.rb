class RubyMotionQuery::Device
  class << self
    def fake_four_inch(value)
      @_four_inch = value
    end
    def reset_fake_four_inch
      @_four_inch = (RubyMotionQuery::Device.height == 568.0)
    end
  end
end
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

  describe "resource_for_device" do
    it "should return the requested file as is if we arent on a 4 inch" do
      @rmq.device.fake_four_inch(false)
      image = @rmq.image.resource_for_device('Default')
      @rmq.device.reset_fake_four_inch
      image.is_a?(UIImage).should.be.true
      image.size.height.should == 480
    end

    it "should get the -568h image on a four inch" do
      @rmq.device.fake_four_inch(true)
      image = @rmq.image.resource_for_device('Default')
      @rmq.device.reset_fake_four_inch
      image.is_a?(UIImage).should.be.true
      image.size.height.should == 568
    end
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
  # TODO test resource with and without caching
end
