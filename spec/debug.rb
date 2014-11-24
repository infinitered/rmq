describe 'debug' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'asserts value is true' do
    a = true
    @rmq.debug.assert(1==1) do
      a = false
      {}
    end
    a.should == true
  end

  it 'randomly colors a selected view' do
    vc = UIViewController.new

    some_view = vc.rmq.append!(UIView)
    some_view.backgroundColor.should == nil
    vc.rmq(some_view).debug.colorize
    some_view.backgroundColor.is_a?(UIColor).should == true
  end
end
