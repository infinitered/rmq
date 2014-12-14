describe 'ext' do

  it 'should return an rmq object when UIViewController#rmq is called' do
    view_controller = UIViewController.alloc.init
    view_controller.rmq.is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should return an rmq object when TopLevel#rmq is called' do
    top = TopLevel.alloc.init
    top.rmq.is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should return an rmq object when Object#rmq is called' do
    jesse_object = "I'm an object yo!"
    jesse_object.rmq.is_a?(RubyMotionQuery::RMQ).should == true
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
    view.rmq.context.should == view
  end

  it 'DEPRECATED - should call rmq_did_create after appending to view' do
    vc = UIViewController.alloc.init
    view = vc.rmq.append(ExtTestView).get
    view.controller.should == vc
  end

  it 'should call rmq_did_create after creating a view' do
    vc = UIViewController.alloc.init
    view = vc.rmq.create(ExtTestView).get
    view.controller.should == vc
    view.created.should == true
    view.appended.nil?.should == true
    view.built.should == true
  end

  it 'should call rmq_build and rmq_appended after appending a view' do
    vc = UIViewController.alloc.init
    view = vc.rmq.append(ExtTestView).get
    view.controller.should == vc
    view.created.should == true
    view.appended.should == true
    view.built.should == true
  end

  it 'should call rmq_build and rmq_appended after appending a existing view' do
    vc = UIViewController.alloc.init
    v = ExtTestView.alloc.initWithFrame(CGRectZero)
    v.created.nil?.should == true
    v.appended.nil?.should == true
    v.built.nil?.should == true
    v.controller.nil?.should == true

    view = vc.rmq.append(v).get
    view.controller.should == vc
    view.created.nil?.should == true
    view.appended.should == true
    view.built.should == true
  end

  it 'should call rmq_build after calling build on a view' do
    v = ExtTestView.alloc.initWithFrame(CGRectZero)
    v.built.should == nil
    rmq.build(v)
    v.built.should == true
  end

  it 'should call rmq_style_applied when applying a style or appending' do
    vc = UIViewController.alloc.init
    vc.rmq.stylesheet = StyleSheetForExtTests

    view = vc.rmq.append(ExtTestView, :style_one).get
    view.style_applied.should == true

    view2 = vc.rmq.append(ExtTestView).get
    view2.style_applied.should != true

    vc.rmq(view2).apply_style(:style_one)
    view2.style_applied.should == true
  end

  it 'should allow you to create another color from color with options' do
    color = UIColor.blueColor.with(alpha: 0.5)
    color.should == UIColor.colorWithRed(0, green: 0, blue: 255, alpha: 0.5)
    color = UIColor.blueColor.with(red: 255)
    color.should == UIColor.colorWithRed(255, green: 0, blue: 255, alpha: 1.0)
  end
end

class ExtTestView < UIView
  attr_accessor :controller, :created, :appended, :built, :style_applied
  def rmq_did_create(rmq)
    @controller = rmq.view_controller
  end

  def rmq_created
    @controller = rmq.view_controller
    @created = true
  end

  def rmq_appended
    @controller = rmq.view_controller
    @appended = true
  end

  def rmq_build
    @controller = rmq.view_controller
    @built = true
  end

  def rmq_style_applied
    @controller = rmq.view_controller
    @style_applied = true
  end

  def get_context
    rmq.context
  end
end

class StyleSheetForExtTests < RubyMotionQuery::Stylesheet
  def style_one(st)
    st.frame = {l: 1}
  end
end
