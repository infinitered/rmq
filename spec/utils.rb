describe 'utils' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'should return true if class is passed to is_class?' do
    @rmq.is_class?(String).should == true
    @rmq.is_class?('hi').should == false
    FOO = :bar
    @rmq.is_class?(FOO).should == false
    @rmq.is_class?(nil).should == false
    @rmq.is_class?(UIView).should == true
  end

  it 'should return true if empty string is passed to is_blank?' do
    @rmq.is_blank?('').should == true
    @rmq.is_blank?('not blank').should == false
  end

  it 'should return true if nil is passed to is_blank?' do
    @rmq.is_blank?(nil).should == true
    @rmq.is_blank?('not nil').should == false
  end

  it 'should return true if empty array is passed to is_blank?' do
    @rmq.is_blank?([]).should == true
    @rmq.is_blank?([:not_emtpy]).should == false
  end

  it 'should return true if empty hash is passed to is_blank?' do
    @rmq.is_blank?({}).should == true
    @rmq.is_blank?({not_emtpy: true}).should == false
  end

  it 'should return a string of a view' do
    v = UIView.alloc.initWithFrame(CGRectZero)
    s = @rmq.view_to_s(v)
    s.is_a?(String) == true
    (s =~ /.*VIEW.*/).should == 1
  end

  it 'should be able to tell if an object is a weak ref when using RubyMotionQuery::RMQ.weak_ref' do
    bar = 'hi there'
    weak_bar = RubyMotionQuery::RMQ.weak_ref(bar)
    RubyMotionQuery::RMQ.is_object_weak_ref?(bar).should == false
    RubyMotionQuery::RMQ.is_object_weak_ref?(weak_bar).should == true
  end

  it 'should be able to tell if an object is a weak ref when using WeakRef.new' do
    foo = 'Foo'
    weak_foo = WeakRef.new(foo)

    RubyMotionQuery::RMQ.is_object_weak_ref?(foo).should == false
    RubyMotionQuery::RMQ.is_object_weak_ref?(weak_foo).should == true
  end

  it 'should not wrap a weak ref inside another weak ref' do
    # RM's standard WeakRef will wrap a weak ref inside aonther weak ref
    # and weakref_alive? then becomes useless
    autorelease_pool do
      @bar = 'bar'
      @bar_weak = WeakRef.new(@bar)
      @bar_weak_in_weak = WeakRef.new(@bar_weak)
      @bar = nil
    end
    @bar_weak.weakref_alive?.should == false
    @bar_weak_in_weak.weakref_alive?.should == true # Wat

    # Now make sure rmq's does not that
    autorelease_pool do
      @foo = 'foo'
      @foo_weak = RubyMotionQuery::RMQ.weak_ref(@foo)
      @foo_weak_in_weak = RubyMotionQuery::RMQ.weak_ref(@foo_weak)
      @foo = nil
    end
    @foo_weak.weakref_alive?.should == false
    @foo_weak_in_weak.weakref_alive?.should == false
  end

  it 'should convert a weak ref into a strong ref' do
    s = "string"
    weak_s = WeakRef.new(s)
    strong_s = RubyMotionQuery::RMQ.weak_ref_to_strong_ref(weak_s)
    strong_s.should == weak_s
    strong_s.object_id.should == s.object_id
    strong_s.is_a?(WeakRef).should == false
    strong_s.is_a?(String).should == true
  end

  describe 'utils - controller_for_view' do
    it 'should return nil if view is nil' do
      @rmq.controller_for_view(nil).should == nil
    end

    it 'should return nil if a view isn\'t in a controller' do
      u = UIView.alloc.initWithFrame(CGRectZero)
      @rmq.controller_for_view(u).should == nil
    end

    it 'should return the controller assigned to the view, if it exists' do
      u = UIView.alloc.initWithFrame(CGRectZero)
      vc = UIViewController.alloc.init
      u.rmq_data.view_controller = vc
      @rmq.controller_for_view(u).should == vc
    end

    it 'should return a view\'s controller' do
      controller = UIViewController.alloc.init
      root_view = controller.view
      @rmq.controller_for_view(root_view).should == controller

      sub_view = UIView.alloc.initWithFrame(CGRectZero)
      root_view.addSubview(sub_view)
      @rmq.controller_for_view(sub_view).should == controller

      sub_sub_view = UIView.alloc.initWithFrame(CGRectZero)
      sub_view.addSubview(sub_sub_view)
      @rmq.controller_for_view(sub_sub_view).should == controller
    end
  end
end
