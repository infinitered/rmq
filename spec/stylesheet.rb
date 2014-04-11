describe 'stylesheet' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForStylesheetTests
  end

  # Some of the tests for stylesheets are in the UIViewStyler's spec

  it 'should be set for a controller' do
    @vc.rmq.stylesheet.is_a?(StyleSheetForStylesheetTests).should == true
  end

  it 'should style all selected' do
    view = UIView.alloc.initWithFrame(CGRectZero)
    @vc.view.addSubview(view)
    view2 = UIView.alloc.initWithFrame(CGRectZero)
    @vc.view.addSubview(view2)
    
    @vc.rmq(view,view2).style do |st|
      st.left = 5
      st.z_position = 2
    end

    view.origin.x.should == 5
    view2.origin.x.should == 5
    view.layer.zPosition.should == 2
    view2.layer.zPosition.should == 2
  end

  it 'should return various rmq objects in a stylesheet instance' do
    # TODO, test all the methods such as Stylesheet#device, etc
    1.should == 1
  end

  it 'should allow application setup, that should only be called once' do
    # TODO
    1.should == 1
  end

  it 'should allow stylesheet setup' do
    # TODO
    1.should == 1
  end

  it 'should get app_size, width, and height' do
    # TODO
    1.should == 1
  end

  it 'should get screen_size, width, and height' do
    # TODO
    1.should == 1
  end

  it 'should get content_size, width, and height' do
    # TODO
    1.should == 1
  end

  it 'should use parent_rmq to get stylesheet if there is no view_controller for the rmq instance' do
    rmq1 = @vc.rmq
    rmq1.append(UILabel)
    rmq1.stylesheet = StyleSheetForStylesheetTests
    ss1 = rmq1.stylesheet
    ss1.is_a?(StyleSheetForStylesheetTests).should == true
    ss1.should == rmq1.stylesheet # seems silly, but it's not

    rmq2 = rmq1.find(UIView) 
    rmq1.view_controller.should == @vc
    rmq2.view_controller.should == @vc
    rmq2.stylesheet.should == rmq2.view_controller.rmq_data.stylesheet
    rmq2.stylesheet.should == ss1

    foo_view = UIView.alloc.initWithFrame(CGRectZero)
    rmq3 = rmq1.wrap(foo_view)
    rmq3.parent_rmq.should == rmq1
    RubyMotionQuery::RMQ.weak_ref_is_same_object?(rmq3.view_controller, rmq1.view_controller).should == true
    rmq3.stylesheet.should == ss1

    bar_view = UIView.alloc.initWithFrame(CGRectZero)
    rmq4 = rmq3.wrap(bar_view)
    rmq4.stylesheet.should == ss1
  end

  it 'should allow rmq in stylesheet as if it\'s in the controller' do
    @vc.rmq.should == @vc.rmq.stylesheet.self_rmq

    q = @vc.rmq.append(UILabel, :style_use_rmq)
    q.get.textColor.should == rmq.color.blue

    ss = StyleSheetForStylesheetTests.new(nil)
    ss.controller.should == nil
    label = UILabel.alloc.initWithFrame(CGRectZero)
    ss.style_use_rmq(@vc.rmq.styler_for(label))
    label.textColor.should == rmq.color.blue
  end

  describe 'styles' do

    it 'should apply style_name to a view' do
      q = @vc.rmq.append(UIView)
      q.get.origin.x.should == 0
      q.apply_style(:style_one)
      q.get.origin.x.should == 1
      q.apply_style(:style_two)
      q.get.origin.x.should == 2
    end

    it 'should reapply styles to views that have already had a style applied' do

      q = @vc.rmq.append(UIView, :style_one)
      view = q.get
      view.origin.x.should == 1
      view.frame = [[5,0],[5,5]]
      view.origin.x.should == 5
      q.reapply_styles
      #view.origin.x.should == 1

      q = @vc.rmq.append(UIView)
      view = q.get
      view.origin.x.should == 0
      q.apply_style(:style_one)
      view.origin.x.should == 1
      view.frame = [[5,0],[5,5]]
      view.origin.x.should == 5
      q.all.reapply_styles
      view.origin.x.should == 1
    end

    it 'should return a styler for various types of views' do
      @vc.rmq.tap do |q|
        q.styler_for(UIView.alloc.init).is_a?(RubyMotionQuery::Stylers::UIViewStyler).should == true
        q.styler_for(UIImageView.alloc.init).is_a?(RubyMotionQuery::Stylers::UIImageViewStyler).should == true
        q.styler_for(UILabel.alloc.init).is_a?(RubyMotionQuery::Stylers::UILabelStyler).should == true
        q.styler_for(UIButton.alloc.init).is_a?(RubyMotionQuery::Stylers::UIButtonStyler).should == true
        q.styler_for(UIScrollView.alloc.init).is_a?(RubyMotionQuery::Stylers::UIScrollViewStyler).should == true
        # TODO, test the rest
      end
    end

  end
end

class StyleSheetForStylesheetTests < RubyMotionQuery::Stylesheet
  def application_setup
    font_family = 'Helvetica Neue'
    font.add_named :large,    font_family, 36
    font.add_named :medium,   font_family, 24
    font.add_named :small,    'Verdana', 18 

    color.add_named :battleship_gray,   '#7F7F7F' 
  end

  def setup
    color.add_named :panther_black, color.black
  end

  def style_one(st)
    st.left = 1
    st.background_color = color.battleship_gray
  end

  def style_two(st)
    st.left = 2
    st.background_color = color.panther_black
  end

  def style_use_rmq(st)
    rmq(st.view).get.textColor = color.blue
  end

  def self_rmq
    rmq
  end
end
