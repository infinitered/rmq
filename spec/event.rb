describe 'event' do
  before do
    @control = UIControl.alloc.initWithFrame(CGRectZero)
  end
  
  it 'should init target' do
    @control.allTargets.count.should == 0
    RubyMotionQuery::RMQ.is_blank?(@control.gestureRecognizers).should == true
    event = RubyMotionQuery::Event.new(@control, :touch, lambda {|sender|;}) 
    RubyMotionQuery::RMQ.is_blank?(@control.gestureRecognizers).should == true
    @control.allTargets.count.should == 1
  end

  it 'should init with gesture' do
    @control.allTargets.count.should == 0
    RubyMotionQuery::RMQ.is_blank?(@control.gestureRecognizers).should == true
    event = RubyMotionQuery::Event.new(@control, :tap, lambda {|sender| ;}) 
    RubyMotionQuery::RMQ.is_blank?(@control.gestureRecognizers).should == false
    @control.allTargets.count.should == 0
  end

  it 'should work with a block with 1 or 2 params' do
    event = RubyMotionQuery::Event.new(@control, :tap, lambda {|sender| ;}) 
    event.block.call(@control)
    should.raise(ArgumentError) do
      event.block.call(@control, event)
    end
    event2 = RubyMotionQuery::Event.new(@control, :tap, lambda {|sender, event| ;}) 

    should.raise(ArgumentError) do
      event2.block.call(@control)
    end
    event2.block.call(@control, event)
  end

  it 'should have various attributes' do
    block = lambda {|sender|;}
    event = RubyMotionQuery::Event.new(@control, :touch, block) 
    event.sender.should == @control
    event.block.should == block
    event.event.should == :touch
    event.recognizer.nil?.should == true
    event.sdk_event_or_recognizer.should == UIControlEventTouchUpInside

    event = RubyMotionQuery::Event.new(@control, :tap, block) 
    event.recognizer.nil?.should == false
  end

  it 'should remove itself' do
    @control.allTargets.count.should == 0
    RubyMotionQuery::RMQ.is_blank?(@control.gestureRecognizers).should == true
    event = RubyMotionQuery::Event.new(@control, :tap, lambda {|sender| ;}) 
    RubyMotionQuery::RMQ.is_blank?(@control.gestureRecognizers).should == false
    event.remove
    RubyMotionQuery::RMQ.is_blank?(@control.gestureRecognizers).should == true

    @control.allTargets.count.should == 0
    event2 = RubyMotionQuery::Event.new(@control, :touch, lambda {|sender|;}) 
    event3 = RubyMotionQuery::Event.new(@control, :touch_down, lambda {|sender|;}) 
    event2.sender.should == @control
    @control.allTargets.count.should == 2
    event2.remove
    @control.allTargets.count.should == 1
    event3.remove
    @control.allTargets.count.should == 0
  end

  it 'should set various options on a event if it\s a gesture' do
    event = RubyMotionQuery::Event.new(@control, :tap, lambda {|sender| ;}) 
    event.gesture?.should == true
    event.set_options cancels_touches_in_view: true, taps_required: 2, fingers_required: 3

    event.recognizer.numberOfTapsRequired.should == 2
    event.recognizer.numberOfTouchesRequired.should == 3
    # TODO, add the rest
  end

  it 'should return as gesture if is one' do
    event = RubyMotionQuery::Event.new(@control, :tap, lambda {|sender| ;}) 
    event.gesture?.should == true

    event2 = RubyMotionQuery::Event.new(@control, :touch, lambda {|sender, event| ;}) 
    event2.gesture?.should == false
  end

  it 'should report location of event' do
    event = RubyMotionQuery::Event.new(@control, :tap, lambda {|sender| ;}) 
    event.location.nil?.should == false
    # TODO, actually test this
    
    event = RubyMotionQuery::Event.new(@control, :touch, lambda {|sender| ;}) 
    event.location.nil?.should == false
    # TODO, actually test this
  end

  it 'should find the location within a given view' do
    event = RubyMotionQuery::Event.new(@control, :tap, lambda {|sender| ;}) 
    event.location_in(RubyMotionQuery::RMQ.app.window).nil?.should == false
    # TODO, actually test this
    
    event = RubyMotionQuery::Event.new(@control, :touch, lambda {|sender| ;}) 
    event.location_in(RubyMotionQuery::RMQ.app.window).nil?.should == false
    ## TODO, actually test this
  end

end
