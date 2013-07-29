describe 'color' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'should return color from RMQ or an instance of rmq' do
    @rmq.color.should == RubyMotionQuery::Color

    rmq = RubyMotionQuery::RMQ.new
    rmq.color.should == RubyMotionQuery::Color
  end
   
  # TODO finish
end
