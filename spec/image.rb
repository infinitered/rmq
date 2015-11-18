class RubyMotionQuery::Device
  class << self
    def fake_height(value)
      reset_fake_caches
      s = size_a
      @_size_a[1] = value
    end

    def reset_fake_caches
      @_three_point_five_inch = nil
      @_four_inch = nil
      @_four_point_seven_inch = nil
      @_five_point_five_inch = nil
      @_twelve_point_nine_inch = nil
      @_size_a = nil
      @_ipad = nil
      @_iphone = nil
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
    it "should get the correct image size for a three point five inch device" do
      @rmq.device.fake_height(480)
      image = @rmq.image.resource_for_device('Default')
      @rmq.device.reset_fake_caches
      image.is_a?(UIImage).should.be.true
      image.size.height.should == 480
    end

    it "should get the -568h image on a four inch" do
      @rmq.device.fake_height(568)
      image = @rmq.image.resource_for_device('Default')
      @rmq.device.reset_fake_caches
      image.is_a?(UIImage).should.be.true
      image.size.height.should == 568
    end

    it "should get the -667h image on a four point seven inch" do
      @rmq.device.fake_height(667)
      image = @rmq.image.resource_for_device('Default')
      @rmq.device.reset_fake_caches
      image.is_a?(UIImage).should.be.true
      image.size.height.should == 667
    end

    it "should get the -736h image on a five point five inch" do
      @rmq.device.fake_height(736)
      image = @rmq.image.resource_for_device('Default')
      @rmq.device.reset_fake_caches
      image.is_a?(UIImage).should.be.true
      image.size.height.should == 736
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

  describe "resource" do
    it "should return the image when cached" do
      image = @rmq.image.resource('logo')

      image.is_a?(UIImage).should.be.true
    end

    it "should return the image when cached is false" do
      image = @rmq.image.resource('logo', {cache: false})

      image.is_a?(UIImage).should.be.true
    end
  end
end
