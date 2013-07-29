# Used throughout the specs
def hash_to_subviews(view, hash, new_hash = {}, view_name = nil)
  return unless view && hash.length > 0 

  hash.each do |k,v|
    if k == :klass
      o = v.alloc.initWithFrame(CGRectZero)
      view.addSubview(o)
      new_hash[view_name] = {
        name: view_name,
        view: o,
        subs: {}
      }
    elsif k == :subs
      hash_to_subviews(new_hash[view_name][:view], v, new_hash[view_name][:subs])
    else
      hash_to_subviews(view, v, new_hash, k)
    end
  end

  new_hash
end

describe 'base' do
  
  it 'should create simplest' do
    RubyMotionQuery::RMQ.new.should.not == nil
  end
  
  it 'set context and get context' do
    rmq = RubyMotionQuery::RMQ.new
    view_controller = UIViewController.alloc.init

    rmq.context = view_controller
    rmq.context.should == view_controller
  end

  it 'set parent_rmq and get parent_rmq' do
    rmq = RubyMotionQuery::RMQ.new
    rmq2 = RubyMotionQuery::RMQ.new
    view_controller = UIViewController.alloc.init

    rmq.parent_rmq = rmq2
    rmq.parent_rmq.should == rmq2
  end

  it 'should create from view controller with UIView selector' do
    view_controller = UIViewController.alloc.init
    view = UIView.alloc.initWithFrame(CGRectZero)
    view_controller.view.addSubview(view)
    rmq = view_controller.rmq(UIView)
    rmq.should.not == nil
    rmq.selectors.should == [UIView]
  end

  it 'should return context, or if controller, controller view, when context_or_context_view called' do
    rmq = RubyMotionQuery::RMQ.new
    view_controller = UIViewController.alloc.init
    view = UIView.alloc.initWithFrame(CGRectZero)
    view_controller.view.addSubview(view)

    rmq.context = view_controller
    rmq.context_or_context_view.should == view_controller.view

    rmq.context = view
    rmq.context_or_context_view.should == view
  end

  it 'should return [view_controller] as origin_views if no parent_rmq' do
    view_controller = UIViewController.alloc.init
    view = UIView.alloc.initWithFrame(CGRectZero)
    view_controller.view.addSubview(view)

    view_controller.rmq.origin_views.should == [view_controller.view]
  end

  # TODO test origin views when transversing is working

  it 'select context if context is UIView and there are no selectors' do
    view_controller = UIViewController.alloc.init
    view = UIView.alloc.initWithFrame(CGRectZero)
    view_controller.view.addSubview(view)

    rmq = RubyMotionQuery::RMQ.new
    rmq.context = view
    rmq.selectors = nil

    rmq.selected.should == [view]
    rmq.get.should == view
    rmq.length.should == 1
  end

  it 'select context.view if context is UIViewController and there are no selectors' do
    view_controller = UIViewController.alloc.init
    view = UIView.alloc.initWithFrame(CGRectZero)
    view_controller.view.addSubview(view)

    rmq = RubyMotionQuery::RMQ.new
    rmq.context = view_controller
    rmq.selectors = nil

    rmq.selected.should == [view_controller.view]
  end

  it 'should set selectors with an array of views and return that array' do
    a = 0.upto(4).map do
      UIView.alloc.initWithFrame(CGRectZero)
    end

    rmq = RubyMotionQuery::RMQ.new
    rmq.context = a.first
    rmq.selected = a
    rmq.selected.should == a
  end

  it 'setting selectors should reset selected' do
    a = 0.upto(4).map do
      UIView.alloc.initWithFrame(CGRectZero)
    end

    rmq = RubyMotionQuery::RMQ.new
    rmq.context = a.first
    rmq.selected = a
    rmq.selected.should == a

    view = a.first
    rmq.selectors = [view]
    rmq.selected.should == [view]
  end

  it 'should match all views with selector' do
    views_hash = {
      v_0: { 
        klass: UIView,
        subs: {
          v_0: { 
            klass: UIView,
            subs: {
              v_0: { klass: UIImageView, subs: { } },
              v_1: { klass: UIImageView, subs: { } },
              v_2: { klass: UIView, subs: { } }
            } 
          }
        }
      }
    }
    view_controller = UIViewController.alloc.init
    views_hash = hash_to_subviews(view_controller.view, views_hash)
    a = view_controller.rmq(UIImageView).to_a
    a[0].should == views_hash[:v_0][:subs][:v_0][:subs][:v_0][:view]
    a[1].should == views_hash[:v_0][:subs][:v_0][:subs][:v_1][:view]
  end

  it 'should extract views from selectors, then match all views in controller that matches selectors' do
    # TODO, break this into multiple tests
    views_hash = {
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
      v_1: { klass: UILabel, subs: { } }
    }
    view_controller = UIViewController.alloc.init
    views_hash = hash_to_subviews(view_controller.view, views_hash)

    view_a = views_hash[:v_0][:subs][:v_0][:subs][:v_1][:view]
    view_b = views_hash[:v_1][:view]

    view_controller.rmq(view_a).view_controller.should == view_controller

    rmq = view_controller.rmq(view_b, UIImageView)
    rmq.context.should == view_controller
    rmq.selectors.should == [view_b, UIImageView]
    a = rmq.to_a
    rmq.selectors.should == [view_b, UIImageView]
    a.length.should == 2
    a[0].should == view_b
    a[1].should == view_a 

    rmq = view_controller.rmq(view_b, UIView)
    a = rmq.to_a
    a.length.should == 8
    a[0].should == view_b

    rmq = view_controller.rmq(view_b, UILabel)
    a = rmq.to_a
    a.length.should == 2
    a[0].should == view_b
    a[1].is_a?(UILabel).should == true
  end

end

