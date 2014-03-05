describe 'device' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'should return device from RMQ or an instance of rmq' do
    @rmq.device.should == RubyMotionQuery::Device

    rmq = RubyMotionQuery::RMQ.new
    rmq.device.should == RubyMotionQuery::Device
  end

  it 'contains "unknown" in device orientations' do
    RubyMotionQuery::Device.orientations[UIDeviceOrientationUnknown].should.not == nil
  end

  # TODO finish
end
