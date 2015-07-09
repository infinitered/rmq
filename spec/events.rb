class EventsTestController < UIViewController
  def add_event
    rmq.append(UIButton).on(:touch) do
      puts 'touched'
    end
  end

  def dealloc
    $events_test_controller_deallocated = true
    super
  end
end

describe 'events on views' do
  before do
    @vc = UIViewController.alloc.init
  end

  it 'should deallocate when a controller is destroyed which containted an event' do
    $events_test_controller_deallocated.should == nil

    autorelease_pool do
      controller = EventsTestController.new
      controller.add_event
      $events_test_controller_deallocated.should == nil
      controller = nil
    end

    $events_test_controller_deallocated.should == true
  end

  it 'should add event on a view' do
    @vc.rmq.append(UIControl).tap do |q|
      q.get.allTargets.count.should == 0
      q.on(:touch) do |sender, event|
        sender.should == q
        event.is_a?(RubyMotionQuery::Event).should == true
      end
      q.get.allTargets.count.should == 1
      # TODO fire the event
    end

    view = @vc.rmq.get
  end

  it 'should add event on multiple views' do
    @vc.rmq.append(UIControl)
    @vc.rmq.append(UIButton).append(UIButton).append(UIButton)
    @vc.rmq.all.length.should == 4
    @vc.rmq(UIButton).on(:touch_down) {|sender| ;}.each do |control|
      control.allTargets.count.should == 1
    end

    @vc.rmq(UIControl).not(UIButton).get.allTargets.count.should == 0
  end

  it 'should add gesture on a view' do
    # TODO dup the events above and do gestures, minor test
    1.should == 1
  end

  it 'should add gesture on multiple views' do
    # TODO dup the events above and do gestures, minor test
    1.should == 1
  end

  it 'should remove single event from view' do
    @vc.rmq.append(UIButton).append(UIButton).append(UIButton)
    first = @vc.rmq(UIButton).first.get
    first.allTargets.count.should == 0
    @vc.rmq(first).on(:touch_start){|o| ;}.on(:touch_stop) {|o| ;}
    first.allTargets.count.should == 2
    @vc.rmq(first).off(:touch_start)
    first.allTargets.count.should == 1

    @vc.rmq(UIView).not(first).each do |control|
      control.allTargets.count.should == 0
    end
  end

  it 'should remove all events from view' do
    @vc.rmq.append(UIButton).append(UIButton).append(UIButton)
    first = @vc.rmq(UIButton).first.get
    first.allTargets.count.should == 0
    @vc.rmq(first).on(:touch_start){|o| ;}.on(:touch_stop){|o| ;}
    first.allTargets.count.should == 2
    @vc.rmq(first).off(:touch_start, :touch_stop)
    first.allTargets.count.should == 0

    @vc.rmq(first).on(:touch_start){|o| ;}.on(:touch_stop){|o| ;}
    first.allTargets.count.should == 2
    @vc.rmq(first).off
    first.allTargets.count.should == 0

    @vc.rmq(UIView).not(first).each do |control|
      control.allTargets.count.should == 0
    end
  end

  it 'should remove single event from all views' do
    @vc.rmq.append(UIButton).append(UIButton).append(UIButton)
    @vc.rmq(UIButton).on(:touch_start){|o| ;}.on(:touch_stop){|o| ;}
    @vc.rmq(UIButton).each do |control|
      control.allTargets.count.should == 2
    end

    @vc.rmq(UIButton).off(:touch_stop, :touch) # :touch will be ignored
    @vc.rmq(UIButton).each do |control|
      control.allTargets.count.should == 1
      control.rmq_data.events.has_event?(:touch_start).should == true
    end
  end

  it 'should remove all events from all views' do
    @vc.rmq.append(UIButton).append(UIButton).append(UIButton)
    @vc.rmq(UIButton).on(:touch_start){|o| ;}.on(:touch_stop){|o| ;}
    @vc.rmq(UIButton).each do |control|
      control.allTargets.count.should == 2
    end

    @vc.rmq.all.off
    @vc.rmq(UIButton).each do |control|
      control.allTargets.count.should == 0
    end
  end

  it 'should enable user interaction for the view when attached' do
    label = UILabel.alloc.init

    label.isUserInteractionEnabled.should == false

    @vc.rmq.append(label)
    @vc.rmq(label).on(:tap){|o| ;}

    label.isUserInteractionEnabled.should == true
  end

  it 'should allow a custom event' do
    view = UIView.new
    @vc.rmq.append(view)

    should.not.raise { @vc.rmq(view).on(:custom) {|o| ;} }
  end

  it 'should trigger the custom event' do
    view = UIView.new
    @vc.rmq.append(view)

    some_value = false
    @vc.rmq(view).on(:custom) do |sender|
      sender.get.should == view
      sender.is_a?(RubyMotionQuery::RMQ).should == true
      some_value = true
    end

    @vc.rmq(view).trigger(:custom)
    some_value.should == true
  end

  it 'should be able to add custom events and trigger them on multiple views' do
    view_1 = @vc.rmq.append!(UIView)
    view_2 = @vc.rmq.append!(UIView)

    view_1_triggerd = false
    view_2_triggerd = false

    @vc.rmq(view_1, view_2).on(:foo) do |sender|
      sender.is_a?(RubyMotionQuery::RMQ).should == true
      view = sender.get
      if view == view_1
        view.should == view_1
        view_1_triggerd = true
      else
        view.should == view_2
        view_2_triggerd = true
      end
    end

    @vc.rmq(view_1, view_2).trigger(:foo)
    view_1_triggerd.should == true
    view_2_triggerd.should == true
  end
end

describe 'events' do
  before do
    @events = RubyMotionQuery::Events.new
    @view = UIControl.alloc.initWithFrame(CGRectZero)
  end

  it 'should return true if it view has events' do
    @events.has_events?.should == false
    @events.on(@view, :tap) {|o|;}
    @events.has_events?.should == true
  end

  it 'should add event to event set' do
    @events.on(@view, :tap, delegate: self, taps_required: 2) do |sender, event|
    end

    # TODO, finish
    1.should == 1
  end

  it 'should raise exception when adding the same event twice' do
    @events.on(@view, :tap) {|o|;}
    should.raise(RuntimeError) do
      @events.on(@view, :tap) {|o|;}
    end
  end

  it 'should return event based on events index' do
    # TODO, finish
    1.should == 1
  end

  it 'should not fail if you remove an event that isnt\'t there' do
    @events.on(@view, :touch_down) {|o|;}
    event_set = @events.instance_variable_get(:@event_set)
    event_set.length.should == 1
    @events.off(:all_editing)
    event_set.length.should == 1
    @events.off(:touch_down, :tap, :editing_did_endonexit)
    event_set.length.should == 0
  end

  it 'should remove all events from event set' do
    @events.on(@view, :tap) {|o|;}
    @events.on(@view, :touch_down) {|o|;}
    @events.instance_variable_get(:@event_set).length.should == 2
    @events.off
    @events.instance_variable_get(:@event_set).length.should == 0
  end

  it 'should remove event from event set' do
    @events.on(@view, :tap) {|o|;}
    @events.on(@view, :touch_down) {|o|;}
    event_set = @events.instance_variable_get(:@event_set)
    event_set.length.should == 2
    @events.off(:tap)
    event_set.length.should == 1
    event_set.keys[0].should == :touch_down

    @events.on(@view, :tap) {|o|;}
    event_set.length.should == 2
    @events.off(:touch_down, :tap)
    event_set.length.should == 0
  end

end
