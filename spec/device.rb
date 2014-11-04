class RubyMotionQuery::Device
  class << self
    def fake_height(value)
      @_three_point_five_inch = nil
      @_four_inch = nil
      @_four_point_seven_inch = nil
      @_five_point_five_inch = nil
      s = size_a
      @_size_a[1] = value
    end

    def reset_fake_caches
      @_three_point_five_inch = nil
      @_four_inch = nil
      @_four_point_seven_inch = nil
      @_five_point_five_inch = nil
      @_size_a = nil
    end
  end
end

describe 'device' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'should return device from RMQ or an instance of rmq' do
    @rmq.device.should == RubyMotionQuery::Device

    rmq = RubyMotionQuery::RMQ.new
    rmq.device.should == RubyMotionQuery::Device
  end

  it 'can detect what iOS version is in use' do
    rmq.device.ios_version.should == UIDevice.currentDevice.systemVersion
    #validate this is numbers and dots
    rmq.device.ios_version.match(/^(\d|\.)+$/).should.not == nil
  end

  it 'lets you know if a queried version of iOS is correct' do
    current_version = rmq.device.ios_version
    rmq.device.is_version?(current_version).should == true
    # fail condition
    rmq.device.is_version?(2).should == false
    # can check with just major version number like 7 for "7.1"
    rmq.device.is_version?(current_version[0]).should == true
  end

  it 'should have a screen' do
    @rmq.device.screen.should == UIScreen.mainScreen
  end

  it 'should return the proper width' do
    @rmq.device.width.should == UIScreen.mainScreen.bounds.size.width
  end

  it 'should return the proper height' do
    @rmq.device.height.should == UIScreen.mainScreen.bounds.size.height
  end

  it 'should return the proper value for ipad?' do
    @rmq.device.ipad?.should == false

    class RubyMotionQuery::Device
      def self.fake_ipad; @_ipad = true; end
    end

    @rmq.device.fake_ipad
    @rmq.device.ipad?.should == true
  end

  it 'should return true for iphone?' do
    @rmq.device.iphone?.should == true

    class RubyMotionQuery::Device
      def self.fake_iphone; @_iphone = false; end
    end

    @rmq.device.fake_iphone
    @rmq.device.iphone?.should == false
  end

  it 'should return the right value for simulator?' do
    @rmq.device.simulator?.should == true

    class RubyMotionQuery::Device
      def self.fake_simulator_value; @_simulator = false; end
    end

    @rmq.device.fake_simulator_value
    @rmq.device.simulator?.should == false
  end

  it 'should return the right value for three_point_five_inch?' do
    @rmq.device.fake_height(480)
    @rmq.device.three_point_five_inch?.should == true

    @rmq.device.fake_height(10)
    @rmq.device.three_point_five_inch?.should == false
    @rmq.device.reset_fake_caches
  end

  it 'should return the right value for four_inch?' do
    @rmq.device.fake_height(568)
    @rmq.device.four_inch?.should == true

    @rmq.device.fake_height(10)
    @rmq.device.four_inch?.should == false
    @rmq.device.reset_fake_caches
  end

  it 'should return the right value for four_point_seven_inch?' do
    @rmq.device.fake_height(667)
    @rmq.device.four_point_seven_inch?.should == true

    @rmq.device.fake_height(10)
    @rmq.device.four_point_seven_inch?.should == false
    @rmq.device.reset_fake_caches
  end

  it 'should return the right value for five_point_five_inch?' do
    @rmq.device.fake_height(736)
    @rmq.device.five_point_five_inch?.should == true

    @rmq.device.fake_height(10)
    @rmq.device.five_point_five_inch?.should == false
    @rmq.device.reset_fake_caches
  end

  it 'detects if the device  is retina' do
    (@rmq.device.screen.scale == 2).should == @rmq.device.retina?
  end

  it 'should report landscape? and portrait? correctly' do
   @rmq.device.orientation = :portrait
   @rmq.device.portrait?.should == true
   @rmq.device.landscape?.should == false

   @rmq.device.orientation = :landscape_left
   @rmq.device.portrait?.should == false
   @rmq.device.landscape?.should == true

   @rmq.device.orientation = nil
  end

  describe 'orientations' do
    it 'should allow you to set your own orientation, that RMQ uses everywhere' do
      @rmq.device.orientation.should == :portrait
      @rmq.device.portrait?.should == true
      @rmq.device.landscape?.should == false

      @rmq.device.screen_width.should == @rmq.device.width
      @rmq.device.screen_height.should == @rmq.device.height

      @rmq.device.orientation = :landscape
      @rmq.device.orientation.should == :landscape_left
      @rmq.device.portrait?.should == false
      @rmq.device.landscape?.should == true

      @rmq.device.screen_width.should == @rmq.device.width_landscape
      @rmq.device.screen_width.should == @rmq.device.height
      @rmq.device.screen_height.should == @rmq.device.height_landscape
      @rmq.device.screen_height.should == @rmq.device.width

      @rmq.device.orientation = nil
      @rmq.device.orientation.should == :portrait
      @rmq.device.screen_width.should == @rmq.device.width
      @rmq.device.screen_height.should == @rmq.device.height
    end

    #TODO finish
  end

  it 'contains "unknown" in device orientations' do
    RubyMotionQuery::Device.orientations[UIDeviceOrientationUnknown].should.not == nil
  end
end
