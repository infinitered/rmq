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
      st.frame = {l: 5}
      st.z_position = 2
    end

    view.origin.x.should == 5
    view2.origin.x.should == 5
    view.layer.zPosition.should == 2
    view2.layer.zPosition.should == 2
  end

  it 'should return various rmq objects in a stylesheet instance' do
    @vc.rmq.stylesheet.grid.is_a?(RubyMotionQuery::Grid).should.be.true
    @vc.rmq.stylesheet.device.should == RubyMotionQuery::Device
    @vc.rmq.stylesheet.image.should == RubyMotionQuery::ImageUtils
    @vc.rmq.stylesheet.color.should == RubyMotionQuery::Color
    @vc.rmq.stylesheet.font.should == RubyMotionQuery::Font
  end

  it 'should return various device objects in a stylesheet instance' do
    ss = @vc.rmq.stylesheet
    device = ss.device

    ss.landscape?.should == device.landscape?
    ss.portrait?.should == device.portrait?
    ss.iphone?.should == device.iphone?
    ss.ipad?.should == device.ipad?
    ss.three_point_five_inch?.should == device.three_point_five_inch?
    ss.four_inch?.should == device.four_inch?
    ss.four_point_seven_inch?.should == device.four_point_seven_inch?
    ss.five_point_five_inch?.should == device.five_point_five_inch?
    ss.retina?.should == device.retina?
  end

  it 'should allow application setup, that should only be called once' do
    RubyMotionQuery::Stylesheet.application_was_setup = nil

    @vc.rmq.stylesheet = StyleSheetForStylesheetTests
    @vc.rmq.stylesheet = StyleSheetForStylesheetTests
    RubyMotionQuery::Stylesheet.application_was_setup.should.be.true
    StyleSheetForStylesheetTests.app_setup_count.should == 1
  end

  it 'should allow stylesheet setup' do
    @vc.rmq.stylesheet = StyleSheetForStylesheetTests
    @vc.rmq.stylesheet.setup_called.should.be.true
  end

  it 'should allow stylesheet to be changed and styles reapplied' do
    @vc.rmq.stylesheet = StyleSheetForStylesheetTests
    q_one = @vc.rmq.append(UIView, :style_one)
    q_full = q_one.append(UIView, :style_full)
    @vc.rmq(:style_full).frame.width.should == 16
    @vc.rmq.stylesheet = StyleSheetForStylesheetTests
    @vc.rmq.all.reapply_styles
    @vc.rmq(:style_full).frame.width.should == 16
  end

  describe 'getting app and screen size, width, and height' do
    before do
      @screen = rmq.device.screen
    end

    it 'should work for all orientations' do
      size = @screen.bounds.size

      rmq.device.orientation = :portrait
      @vc.rmq.stylesheet.screen_width.should == size.width
      @vc.rmq.stylesheet.screen_height.should == size.height

      rmq.device.orientation = :landscape_left
      @vc.rmq.stylesheet.screen_width.should == size.height
      @vc.rmq.stylesheet.screen_height.should == size.width

      rmq.device.orientation = :landscape_right
      @vc.rmq.stylesheet.screen_width.should == size.height
      @vc.rmq.stylesheet.screen_height.should == size.width

      rmq.device.orientation = nil
      @vc.rmq.stylesheet.screen_width.should == size.width
      @vc.rmq.stylesheet.screen_height.should == size.height
    end
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
    rmq3.view_controller.should == rmq1.view_controller
    rmq3.stylesheet.should == ss1

    bar_view = UIView.alloc.initWithFrame(CGRectZero)
    rmq4 = rmq3.wrap(bar_view)
    rmq4.stylesheet.should == ss1
  end

  it 'should allow rmq in stylesheet as if it\'s in the controller' do
    @vc.rmq.stylesheet.controller.should == @vc

    q = @vc.rmq.append(UILabel, :style_use_rmq)
    q.get.textColor.should == rmq.color.blue

    ss = StyleSheetForStylesheetTests.new(nil)
    ss.controller.should == nil
    label = UILabel.alloc.initWithFrame(CGRectZero)
    ss.style_use_rmq(@vc.rmq.styler_for(label))
    label.textColor.should == rmq.color.blue
  end

  it 'should allow rmq in stylesheet to select any view in controller' do
    @vc.rmq.append(UILabel, :style_use_rmq)
    @vc.rmq.append(UILabel, :style_use_rmq)
    @vc.rmq.append(UIView).append(UILabel)

    vcs_stylesheet = @vc.rmq.stylesheet

    vcs_stylesheet.rmq(:style_use_rmq).length.should == 2
    vcs_stylesheet.rmq(UILabel).length.should == 3
    vcs_stylesheet.rmq(UIButton).length.should == 0
    vcs_stylesheet.rmq(UIView).length.should == 4
    vcs_stylesheet.rmq.find(UIView).length.should == 4
    vcs_stylesheet.rmq.all.length.should == 4
    vcs_stylesheet.rmq.length.should == 1 # Only root_view

    rmq(UIView).length.should != 4 # RMQ should use current controller, not the stylesheets
  end

  it 'should locate the current controller if the stylesheet doesn\'t have a controller assigned' do
    ss = StyleSheetForStylesheetTests.new(nil)
    ss.rmq(UIView).first.get.should == rmq(UIView).first.get # No controller assigned to styleshe
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

    it 'should apply multiple style_names with .apply_styles' do
      view1_q = @vc.rmq.append(UIView).layout(l: 5, t: 5, w: 10, h: 15)
      view2_q = view1_q.append(UIView).apply_style(:style_set_frame, :style_set_background)

      view2_q.frame.size.should == view1_q.frame.size
      view2_q.get.backgroundColor.should == rmq.color.yellow

      # Also with alias
      view2_q = view1_q.append(UIView).apply_styles(:style_set_frame, :style_set_background)
      view2_q.frame.size.should == view1_q.frame.size
      view2_q.get.backgroundColor.should == rmq.color.yellow
    end

    it 'should apply multiple style_names to a view, in order' do
      q = @vc.rmq.append(UIView)
      q.get.origin.x.should == 0
      q.apply_style(:style_one, :style_two)
      q.get.origin.x.should == 2
      q.apply_style(:style_two, :style_one)
      q.get.origin.x.should == 1
    end

    it 'should reapply multiple style_names to a view, in order' do
      q = @vc.rmq.append(UIView)
      q.apply_style(:style_two, :style_one, :style_set_background)
      q.get.backgroundColor.should == rmq.color.yellow
      q.get.origin.x.should == 1

      q.style{|st| st.background_color = rmq.color.green}.layout(x: 10)
      q.get.origin.x.should == 10
      q.get.backgroundColor.should == rmq.color.green

      q.reapply_styles
      q.get.origin.x.should == 1
      q.get.backgroundColor.should == rmq.color.yellow
    end

    it 'should respond if a view or set of views ALL have a particuliar style' do
      q = @vc.rmq.append(UIView)
      q2 = @vc.rmq.append(UIView)
      q.apply_style(:style_two, :style_one)

      # Apply the styles seperatly
      q2.apply_style(:style_set_background)
      q2.apply_style(:style_one)

      both = rmq(q.get, q2.get)

      q.has_style?(:style_one).should == true
      q.has_style?(:style_two).should == true
      q.has_style?(:style_set_background).should == false

      both.has_style?(:style_one).should == true
      both.has_style?(:style_two).should == false
      both.has_style?(:style_set_background).should == false
    end

    it 'should return all the styles, in order, that is applied to a view or views' do
      q = @vc.rmq.append(UIView)
      q2 = @vc.rmq.append(UIView)
      q.apply_style(:style_two, :style_one)

      # Apply the styles seperatly
      q2.apply_style(:style_set_background)
      q2.apply_style(:style_one)

      both = rmq(q.get, q2.get)

      @vc.rmq.append(UIView).styles.should == []

      q.styles.should == [:style_two, :style_one]
      q2.styles.should == [:style_set_background, :style_one]
      both.styles.should == [:style_two, :style_one, :style_set_background]
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
      q.reapply_styles
      view.origin.x.should == 1
    end

    it 'should allow you to remove a style from a view' do
      q = @vc.rmq.append(UIView, :style_one)
      q.apply_style(:style_two)
      q.remove_style(:style_one)
      q.styles.should == [:style_two]
    end

    it 'should allow you to remove all styles from a view' do
      q = @vc.rmq.append(UIView, :style_one)
      q.styles.should == [:style_one]
      q.apply_style(:style_two)
      q.styles.should == [:style_one, :style_two]
      q.remove_all_styles
      q.styles.should == []
    end

    it 'should return a styler for various types of views' do
      @vc.rmq.tap do |q|
        q.styler_for(UIView.alloc.init).is_a?(RubyMotionQuery::Stylers::UIViewStyler).should == true
        q.styler_for(UIControl.alloc.init).is_a?(RubyMotionQuery::Stylers::UIControlStyler).should == true
        q.styler_for(UIImageView.alloc.init).is_a?(RubyMotionQuery::Stylers::UIImageViewStyler).should == true
        q.styler_for(UILabel.alloc.init).is_a?(RubyMotionQuery::Stylers::UILabelStyler).should == true
        q.styler_for(UIButton.alloc.init).is_a?(RubyMotionQuery::Stylers::UIButtonStyler).should == true
        q.styler_for(UIScrollView.alloc.init).is_a?(RubyMotionQuery::Stylers::UIScrollViewStyler).should == true
        q.styler_for(UIProgressView.alloc.initWithProgressViewStyle(UIProgressViewStyleDefault)).is_a?(RubyMotionQuery::Stylers::UIProgressViewStyler).should == true
        q.styler_for(UITableView.alloc.init).is_a?(RubyMotionQuery::Stylers::UITableViewStyler).should.be.true
        q.styler_for(UISwitch.alloc.init).is_a?(RubyMotionQuery::Stylers::UISwitchStyler).should.be.true
        q.styler_for(UIDatePicker.alloc.init).is_a?(RubyMotionQuery::Stylers::UIDatePickerStyler).should.be.true
        q.styler_for(UISegmentedControl.alloc.init).is_a?(RubyMotionQuery::Stylers::UISegmentedControlStyler).should.be.true
        q.styler_for(UIRefreshControl.alloc.init).is_a?(RubyMotionQuery::Stylers::UIRefreshControlStyler).should.be.true
        q.styler_for(UIPageControl.alloc.init).is_a?(RubyMotionQuery::Stylers::UIPageControlStyler).should.be.true
        q.styler_for(UISlider.alloc.init).is_a?(RubyMotionQuery::Stylers::UISliderStyler).should.be.true
        q.styler_for(UIStepper.alloc.init).is_a?(RubyMotionQuery::Stylers::UIStepperStyler).should.be.true
        q.styler_for(UITabBar.alloc.init).is_a?(RubyMotionQuery::Stylers::UITabBarStyler).should.be.true
        q.styler_for(UITableViewCell.alloc.init).is_a?(RubyMotionQuery::Stylers::UITableViewCellStyler).should.be.true
        q.styler_for(UITextView.alloc.init).is_a?(RubyMotionQuery::Stylers::UITextViewStyler).should.be.true
        q.styler_for(UITextField.alloc.init).is_a?(RubyMotionQuery::Stylers::UITextFieldStyler).should.be.true
        q.styler_for(UINavigationBar.alloc.init).is_a?(RubyMotionQuery::Stylers::UINavigationBarStyler).should.be.true
        q.styler_for(UIScrollView.alloc.init).is_a?(RubyMotionQuery::Stylers::UIScrollViewStyler).should.be.true
      end
    end

    it 'should return rmq_styler if the view supports a customer styler' do
      v = TestClassWithCustomerStyler.new
      styler = rmq.styler_for(v)
      styler.is_a?(TestClassWithCustomerStyler).should == true
      styler.view.should == v
    end

  end
end

class StyleSheetForStylesheetTests < RubyMotionQuery::Stylesheet
  class << self
    attr_accessor :app_setup_count
  end

  attr_accessor :setup_called

  def application_setup
    font_family = 'Helvetica Neue'
    font.add_named :large,    font_family, 36
    font.add_named :medium,   font_family, 24
    font.add_named :small,    'Verdana', 18

    color.add_named :battleship_gray,   '#7F7F7F'
    self.class.app_setup_count ||= 0
    self.class.app_setup_count += 1
  end

  def setup
    self.setup_called = true
    color.add_named :panther_black, color.black
  end

  def style_one(st)
    st.frame = {l: 1, w: 16}
    st.background_color = color.battleship_gray
  end

  def style_two(st)
    st.frame = {l: 2}
    st.background_color = color.panther_black
  end

  def style_set_frame(st)
    st.frame = :full
  end

  def style_set_background(st)
    st.background_color = color.yellow
  end

  def style_use_rmq(st)
    rmq(st.view).get.textColor = color.blue
  end

  def style_full(st)
    st.frame = :full if st.view.superview
  end

  def digits_field(st)
    st.validation_errors = {
      digits: "custom error messsage"
    }
  end

  def self_rmq
    rmq
  end
end

class TestClassWithCustomerStyler < UIControl
  attr_accessor :view
  def rmq_styler
    # Just using self here for testing, normally you would create your styler class
    out = TestClassWithCustomerStyler.new
    out.view = self
    out
  end
end
