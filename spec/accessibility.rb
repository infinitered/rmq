describe 'accessibility' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'should return accessibility from RMQ or an instance of rmq' do
    @rmq.accessibility.should == RubyMotionQuery::Accessibility

    rmq = RubyMotionQuery::RMQ.new
    rmq.accessibility.should == RubyMotionQuery::Accessibility
  end

  it 'should return if voiceover is currently running' do
    rmq.accessibility.voiceover_running?.should.be.false
  end
end
