describe 'transversing' do
  before do
    @vc = UIViewController.alloc.init
    @root_view = @vc.view

    @views_hash = {
      v_0: { 
        klass: UIView,
        subs: {
          v_0: { 
            klass: UIView,
            subs: {
              v_0: { klass: UIView, subs: { } },
              v_1: { klass: UIImageView, subs: { } },
              v_2: { klass: UIView, subs: { } }
            } 
          },
          v_1: { klass: UILabel, subs: { } },
          v_2: { klass: UIView, subs: { } } 
        }
      },
      v_1: { klass: UILabel, subs: { } },
      v_2: { klass: UILabel, subs: { } },
      v_3: { 
        klass: UIView,
        subs: {
          v_0: { klass: UIView, subs: { } },
          v_1: { klass: UIView, subs: { } },
          v_2: {
            klass: UIView,
            subs: {
              v_0: { klass: UIView,
                subs: {
                  v_0: { klass: UILabel, subs: { } },
                  v_1: { klass: UIView, subs: { } },
                  v_2: { klass: UIImageView, subs: { } }
                } 
              }
            }
          }
        }
      }
    }

    @views_hash = hash_to_subviews(@root_view, @views_hash)
    @v0 = @views_hash[:v_0][:view]
    @v3_v2_v0 = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:view]
    @last_image = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_2][:view]
    @total_views = 17
  end

  it 'locate view given view' do
    q = @vc.rmq(@last_image)
    q.length.should == 1
    q.get.should == @last_image
  end


  it 'should return empty array for root_view closest' do
    closest = @vc.rmq(@root_view).closest
    closest.should.not == nil
    closest.is_a?(RubyMotionQuery::RMQ).should == true
    RubyMotionQuery::RMQ.is_blank?(closest).should == true
  end

  it 'should return root_view of the controller' do
    @vc.rmq.root_view.should == @vc.view
  end

  it 'should return empty array for root_view parent' do
    parent = @vc.rmq(@root_view).parent
    parent.should.not == nil
    parent.is_a?(RubyMotionQuery::RMQ).should == true
    RubyMotionQuery::RMQ.is_blank?(parent).should == true
  end

  it 'should return empty array for root_view parents' do
    @vc.rmq(@vc.view).parents.length.should == 0
  end

  it 'should filter given a block' do
    q = @vc.rmq.all.filter { |view| view.is_a?(UIImageView) }
    q.is_a?(RubyMotionQuery::RMQ).should == true
    q.length.should == 2

    q = @vc.rmq.all.filter(return_array: true) { |view| view.is_a?(UIImageView) }
    q.is_a?(NSArray).should == true


    q = @vc.rmq(UILabel, UIView).filter(limit: 1) do |view|
      view.is_a?(UILabel)
    end
    q.length.should == 1

    q = @vc.rmq(UIView).filter do |view|
      @vc.rmq(view).find.get
    end
    q.length.should == 23

    q = @vc.rmq(UIView).filter(uniq: true) do |view|
      @vc.rmq(view).find.get
    end
    q.length.should == @total_views - 4 # top level views
  end


  it 'select all subview children, grandchildren, etc for controller and view' do
    rmq = @vc.rmq
    rmq.should.not == nil

    all = rmq.all.to_a
    all.length.should == @total_views
    all[0].should == @v0
    all[1].should == @views_hash[:v_0][:subs][:v_0][:view]
    all[2].should == @views_hash[:v_0][:subs][:v_0][:subs][:v_0][:view]
    all[3].should == @views_hash[:v_0][:subs][:v_0][:subs][:v_1][:view]
    all[4].should == @views_hash[:v_0][:subs][:v_0][:subs][:v_2][:view]
    all[5].should == @views_hash[:v_0][:subs][:v_1][:view]

    all.last.should == @last_image
    @last_image.is_a?(UIImageView).should == true
  end

  it 'get closest super view, searching for constant' do
    @vc.rmq(@views_hash[:v_0][:subs][:v_1][:view]).closest(UIViewController).get.should == @vc
    @vc.rmq(@views_hash[:v_0][:subs][:v_0][:subs][:v_1][:view]).closest(UIView).get.should == @views_hash[:v_0][:subs][:v_0][:view]
  end

  it 'get closest super view, searching for constant, with multiple selected' do
    image_views = @vc.rmq(UIImageView)
    closest = image_views.closest(UIView)
    closest.length.should == 2
    a = closest.to_a
    a[0].should == @views_hash[:v_0][:subs][:v_0][:view]
    a[1].should == @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:view]
  end

  it 'should remove views from selected when using .not' do
    rmq = @vc.rmq(UIImageView).not(@last_image)

    rmq.length.should == 1
    rmq.get.should == @views_hash[:v_0][:subs][:v_0][:subs][:v_1][:view]
  end

  it 'should restrict selected when using .and' do
    q = @vc.rmq(@v0).children
    q.length.should == 3
    q.and(UILabel).length.should == 1
    q.and(UILabel).get.is_a?(UILabel).should == true

    # TODO, a few more scenarios here woudl be good
  end

  it 'should add parent to selected when using .and_self' do
    test_view = @v0
    q = @vc.rmq(test_view).children
    q.length.should == 3
    q.get.should.not.include(test_view)
    q = q.add_self
    q.length.should == 4
    q.get.should.include(test_view)
  end

  it 'should return parent rmq using .end' do
    test_view = @v0

    a = @vc.rmq(test_view)
    a.get.should == @vc.rmq(test_view).children.end.get

    # This is a good example of when you'd use .end
    @vc.rmq(test_view).find(UIImageView).tag(:foo).end.find(UILabel).tag(:bar)

    @vc.rmq(:foo).get.should == @vc.rmq(test_view).find(UIImageView).get
    @vc.rmq(:bar).get.should == @vc.rmq(test_view).find(UILabel).get
  end

  it 'should return parent / superview' do
    @vc.rmq(@last_image).parent.get.should == @v3_v2_v0
    @vc.rmq(@last_image).superview.get.should == @v3_v2_v0
    @vc.rmq(UIImageView).parent.length.should == 2
  end

  it 'should return parents / superviews' do
    @vc.rmq(@last_image).parents.length.should == 4

    @vc.rmq.all.parents.length.should == 6 # All views that have subviews 
  end

  it 'should return children of a view' do
    q = @vc.rmq(@v0).children
    q.length.should == 3

    q = @vc.rmq(@v0).find # children and sub children
    q.length.should == 6

    q = @vc.rmq(@views_hash[:v_1][:view]).children
    q.length.should == 0
  end

  it 'should return children of multiple views' do
    @vc.rmq.all.children.length.should == @total_views - 4 # top views
    q = @vc.rmq(@v0, @v3_v2_v0).children
    q.length.should == 6
    q.get.should.include(@last_image)
    q.get.should.not.include(@v3_v2_v0)
    q.get.should.not.include(@v0)
  end

  it 'should return children and sub-children of a view using .find' do
    @vc.rmq.find.length.should == @total_views
    @vc.rmq.all.find.length.should == @total_views - 4 # top views
    @vc.rmq(@v0).find.length.should == 6
    @vc.rmq(@v0).find(UILabel).length.should == 1
    @vc.rmq(@v3_v2_v0).find(UIImageView).get.should == @last_image
  end

  it 'should return children and sub-children of multiple views using .find' do
    @vc.rmq.all.length.should == @total_views 
    @vc.rmq(UIView).length.should == @total_views 
    @vc.rmq.find.length.should == @total_views 
    @vc.rmq.find(UIView).length.should == @total_views 

    @vc.rmq.children(UIView).find(UILabel).length.should == 2
  end

  it 'should return the siblings of a view' do
    test_view = @views_hash[:v_0][:subs][:v_0][:subs][:v_1][:view]
    q = @vc.rmq(test_view)
    q.get.should == test_view
    q = q.siblings
    q.length.should == (test_view.superview.subviews.length - 1) 
    q.get.should.not.include(test_view)
  end

  it 'should return the siblings of multiple views' do
    q = @vc.rmq(UIImageView)
    q.length.should == 2
    qsiblings = q.siblings
    qsiblings.length.should == 4
    qsiblings.get.should.not.include(q.get)

    qsiblings.not(UILabel).length.should == 3
  end

  it 'should return next sibling of a view' do
    test_view = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_1][:view]
    @vc.rmq(test_view).next.get.should == @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_2][:view]
  end

  it 'should return previous sibling of a view' do
    test_view = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_1][:view]
    @vc.rmq(test_view).prev.get.should == @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_0][:view]
  end

  it 'next should return empty rmq if it is at the end of the subviews' do
    @vc.rmq(@v3_v2_v0).next.length.should == 0

    test_view = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_2][:view]
    @vc.rmq(test_view).next.length.should == 0
  end

  it 'next should return empty rmq if it is at the end of the subviews' do
    @vc.rmq(@v3_v2_v0).prev.length.should == 0

    test_view = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_0][:view]
    @vc.rmq(test_view).prev.length.should == 0
  end

  it 'should return next sibling of a multiple views' do
    test_view_0 = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_0][:view]
    test_view_1 = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_1][:view]
    test_view_2 = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_2][:view]
    @vc.rmq(test_view_0, test_view_1).next.get.should == [test_view_1, test_view_2]
  end

  it 'should return next sibling of a multiple views' do
    test_view_0 = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_0][:view]
    test_view_1 = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_1][:view]
    test_view_2 = @views_hash[:v_3][:subs][:v_2][:subs][:v_0][:subs][:v_2][:view]
    @vc.rmq(test_view_1, test_view_2).prev.get.should == [test_view_0, test_view_1]
  end

  it 'should return the window that the controller is sitting in' do
    @vc.rmq.window.should == @vc.view.window
  end

  describe 'rmq.view controller' do
    before do
      @vc1 = UIViewController.alloc.init
      @vc2 = UIViewController.alloc.init
    end

    it 'should be located if the rmq methods is called from within a controller' do
      @vc1.rmq.view_controller.should == @vc1
    end

    it "should always return the controller that the rmq method is called in, regardless if the view it's wrapping has its own controller" do
      @vc2.rmq.view_controller.should == @vc2
      view_1 = UIView.alloc.initWithFrame(CGRectZero)
      view_1.rmq_data.view_controller = @vc1

      # This rmq instance won't be associated with any controller
      RubyMotionQuery::RMQ.new.wrap(view_1).view_controller.should == @vc1

      @vc2.rmq(view_1).view_controller.should == @vc2
    end

    it 'should be the current controller, if a view is not in a subview tree and that view has NOT been assigned a view_controller to rmq_data' do
      view_4 = UIView.alloc.initWithFrame(CGRectZero)

      q = RubyMotionQuery::RMQ.new
      q.wrap(view_4).view_controller.should == q.app.window.rootViewController.visibleViewController
    end

    it 'should be located from any view if the view is in subview tree of a controller' do
      @v0.rmq.view_controller.should == @vc
      @last_image.rmq.view_controller.should == @vc

      view_1 = @vc2.rmq.append(UIView).get
      view_1.rmq.view_controller.should == @vc2

      view_2 = UIView.alloc.initWithFrame(CGRectZero)
      view_1.addSubview(view_2)
      view_2.rmq.view_controller.should == @vc2

      view_3 = UIView.alloc.initWithFrame(CGRectZero)
      view_2.addSubview(view_3)
      view_3.rmq.view_controller.should == @vc2
    end

    it 'should be located if a view is not in a subview tree and that view has been assigned a view_controller to rmq_data' do
      view_1 = @vc2.rmq.create(UIView).get
      view_1.rmq_data.view_controller.should == @vc2
      view_1.rmq.view_controller.should == @vc2
      RubyMotionQuery::RMQ.new.wrap(view_1).view_controller.should == @vc2

      @vc.rmq.append(view_1)
      RubyMotionQuery::RMQ.new.wrap(view_1).view_controller.should == @vc
      view_1.rmq_data.view_controller.should == @vc
      view_1.rmq.view_controller.should == @vc
     
      view_2 = UIView.alloc.initWithFrame(CGRectZero)
      view_2.rmq_data.view_controller = @vc2
      RubyMotionQuery::RMQ.new.wrap(view_2).view_controller.should == @vc2
    end

    it 'should assign a found controller to a view that didn\'t have one' do
      orphan_view = UIView.alloc.initWithFrame(CGRectZero)
      orphan_view.rmq_data.view_controller.should == nil
      vc = orphan_view.rmq.view_controller
      orphan_view.rmq_data.view_controller.should == vc
    end

    it 'should not wrap a WeakRef in another WeakRef (was bug)' do
      # Many ways to cause this bug, I'll do a few here
      q = @vc1.rmq
      q.view_controller = @vc1
      view = q.append(UIView).get
      view.rmq.append(UIView)
      q2 = view.rmq.wrap(UIView)
      q2.view_controller.is_a?(UIViewController).should == true

      view.rmq.context.rmq_data.view_controller.is_a?(UIViewController).should == true

      orphan_view = UIView.alloc.initWithFrame(CGRectZero)
      orphan_view.rmq_data.view_controller = rmq(orphan_view).view_controller
      orphan_view.rmq.view_controller = orphan_view.rmq_data.view_controller
      orphan_view.rmq.view_controller.is_a?(UIViewController).should == true
    end
  end

end
