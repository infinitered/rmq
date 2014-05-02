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

  it 'should not wrap a weak ref inside another weak ref' do
    foo = 'hi'

    # RM's standard WeakRef will wrap a weak ref inside aonther weak ref
    # THIS IS NO LONGER TRUE IN RubyMotion 2.17, disabling test
    #rm_weak = WeakRef.new(foo)
    #rm_weak.is_a?(String).should == true
    #rm_weak = WeakRef.new(rm_weak)
    #rm_weak.is_a?(WeakRef).should == true

    # Now make sure rmq's does not
    weak = RubyMotionQuery::RMQ.weak_ref(foo)
    weak.is_a?(String).should == true
    weak = RubyMotionQuery::RMQ.weak_ref(weak)
    weak.is_a?(WeakRef).should == false
    weak.is_a?(String).should == true
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
