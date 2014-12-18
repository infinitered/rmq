describe 'factory' do
  it 'should create with nil selectors' do
    view = UIView.alloc.initWithFrame(CGRectZero)
    rmq = RubyMotionQuery::RMQ.create_with_selectors(nil, view)
    rmq.should.not == nil
    rmq.context.should == view
  end

  it 'should set context to the controller' do
    u = UIView.alloc.initWithFrame(CGRectZero)
    vc = UIViewController.alloc.init
    vc.view.addSubview(u)
    q = RubyMotionQuery::RMQ.create_with_selectors(nil, vc)
    q.context.should == vc
  end

  it 'should create blank RMQ from existing RMQ' do
    view_controller = UIViewController.alloc.init
    view = UIView.alloc.initWithFrame(CGRectZero)
    rmq = view_controller.rmq(UIView)
    blank_rmq = rmq.create_blank_rmq
    blank_rmq.is_a?(RubyMotionQuery::RMQ).should == true
    blank_rmq.length.should == 0
    rmq.context.should == blank_rmq.context
    blank_rmq.selectors.should == rmq.selectors
    blank_rmq.to_a.should == []
  end

  # TODO test create_rmq_in_context, create_with_array_and_selectors
end
