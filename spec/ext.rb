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

  it 'should set context to controller if rmq is called from within a controller' do
    view_controller = UIViewController.alloc.init
    view_controller.rmq.context.should == view_controller
  end

  it 'should set context to the view if rmq is called from within a view' do
    vc = UIViewController.alloc.init
    view = vc.rmq.append(ExtTestView).get

    view.get_context.should == view
  end

  it 'should call rmq_did_create after appending to view' do
    vc = UIViewController.alloc.init
    view = vc.rmq.append(ExtTestView).get
    view.controller.should == vc
  end
end

class ExtTestView < UIView
  attr_accessor :controller
  def rmq_did_create(rmq)
    @controller = rmq.view_controller
  end

  def get_context
    rmq.context
  end
end
