describe 'ext' do

  it 'should return an rmq object when UIViewController#rmq is called' do
    view_controller = UIViewController.alloc.init
    view_controller.rmq.is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should return an rmq object when TopLevel#rmq is called' do
    top = TopLevel.alloc.init
    top.rmq.is_a?(RubyMotionQuery::RMQ).should == true
  end
  
  it 'should auto create rmq_data on a view if it doesn\'t exist' do
    vc = UIViewController.alloc.init
    view = vc.rmq.append(UIView).get

    view.rmq_data.class.should == RubyMotionQuery::ViewData
    view.rmq_data.should == view.rmq_data # should be same object
  end

  it 'should auto create rmq_data on a view controller if it doesn\'t exist' do
    vc = UIViewController.alloc.init
    vc.rmq_data.class.should == RubyMotionQuery::ControllerData
    vc.rmq_data.should == vc.rmq_data # should be same object
  end
end
