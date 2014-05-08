
describe 'swipe events' do

  before do
    @control = UIControl.alloc.initWithFrame(CGRectZero)
  end

  # Todd, I'll leave this here if you ever change your mind about swipe-event collisions
  it 'should not enforce collisions between swipe_* events and straight-up swipe' do
    RubyMotionQuery::Event.new(@control, :swipe, lambda {|sender| ;})
    RubyMotionQuery::Event.new(@control, :swipe_up, lambda {|sender| ;})
    RubyMotionQuery::Event.new(@control, :swipe_down, lambda {|sender| ;})
    RubyMotionQuery::Event.new(@control, :swipe_left, lambda {|sender| ;})
    RubyMotionQuery::Event.new(@control, :swipe_right, lambda {|sender| ;})
    @control.gestureRecognizers.count.should == 5
  end

  it 'should be a gesture when using swipe_up' do
    event = RubyMotionQuery::Event.new(@control, :swipe_up, lambda {|sender| ;})
    event.gesture?.should == true
  end

  it 'should be a gesture when using swipe_down' do
    event = RubyMotionQuery::Event.new(@control, :swipe_down, lambda {|sender| ;})
    event.gesture?.should == true
  end

  it 'should be a gesture when using swipe_left' do
    event = RubyMotionQuery::Event.new(@control, :swipe_left, lambda {|sender| ;})
    event.gesture?.should == true
  end

  it 'should be a gesture when using swipe_right' do
    event = RubyMotionQuery::Event.new(@control, :swipe_right, lambda {|sender| ;})
    event.gesture?.should == true
  end

  it 'should set recognizer to up when not specifying a direction option' do
    event = RubyMotionQuery::Event.new(@control, :swipe_up, lambda {|sender| ;})
    event.set_options foo:1
    event.recognizer.direction.should == UISwipeGestureRecognizerDirectionUp
  end

  it 'should set recognizer to down when not specifying a direction option' do
    event = RubyMotionQuery::Event.new(@control, :swipe_down, lambda {|sender| ;})
    event.set_options foo:1
    event.recognizer.direction.should == UISwipeGestureRecognizerDirectionDown
  end

  it 'should set recognizer to left when not specifying a direction option' do
    event = RubyMotionQuery::Event.new(@control, :swipe_left, lambda {|sender| ;})
    event.set_options foo:1
    event.recognizer.direction.should == UISwipeGestureRecognizerDirectionLeft
  end

  it 'should set recognizer to right when not specifying a direction option' do
    event = RubyMotionQuery::Event.new(@control, :swipe_right, lambda {|sender| ;})
    event.set_options foo:1
    event.recognizer.direction.should == UISwipeGestureRecognizerDirectionRight
  end

  it 'should set recognizer to up and override the direction option' do
    event = RubyMotionQuery::Event.new(@control, :swipe_up, lambda {|sender| ;})
    event.set_options direction:69
    event.recognizer.direction.should == UISwipeGestureRecognizerDirectionUp
  end

  it 'should set recognizer to down and override the direction option' do
    event = RubyMotionQuery::Event.new(@control, :swipe_down, lambda {|sender| ;})
    event.set_options direction:69
    event.recognizer.direction.should == UISwipeGestureRecognizerDirectionDown
  end

  it 'should set recognizer to left and override the direction option' do
    event = RubyMotionQuery::Event.new(@control, :swipe_left, lambda {|sender| ;})
    event.set_options direction:69
    event.recognizer.direction.should == UISwipeGestureRecognizerDirectionLeft
  end

  it 'should set recognizer to right and override the direction option' do
    event = RubyMotionQuery::Event.new(@control, :swipe_right, lambda {|sender| ;})
    event.set_options direction:69
    event.recognizer.direction.should == UISwipeGestureRecognizerDirectionRight
  end

end
