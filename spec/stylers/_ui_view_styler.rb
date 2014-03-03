class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet
  def my_style(st)
    st.frame = {l: 1, t: 2, w: 3, h: 4}
    st.background_color = RubyMotionQuery::Color.red
    st.background_color = color.red
    st.tint_color = color.red
  end

  def complete_frame(st)
    st.frame = {l: 5, top: 10, w: 20, height: 30}
  end

  def partial_frame_size(st)
    st.frame = {width: 20, h: 30}
  end

  def partial_frame_location(st)
    st.frame = {left: 5, t: 10}
  end

  def real_frame(st)
    st.frame = CGRectMake(5, 10, 20, 30)
  end

  def array_frame(st)
    st.frame = [[5, 10], [20, 30]]
  end

  def ui_view_kitchen_sink(st)
    st.frame = {l: 1, t: 2, w: 3, h: 4}
    st.frame = {left: 1, top: 2, width: 3, height: 4}
    st.frame = {left: 10}
    st.left = 20
    st.top = 30
    st.width = 40
    st.height = 50
    st.right = 100
    st.bottom = 110
    st.from_right = 10
    st.from_bottom = 12
    st.padded = {l: 1, t: 2, r: 3, b: 4}
    st.padded = {left: 1, top: 2, right: 3, bottom: 4}
    st.center = st.superview.center
    st.center_x = 50
    st.center_y = 60
    st.centered = :horizontal
    st.centered = :vertical
    st.centered = :both

    st.enabled = true
    st.hidden = false
    st.z_position = 66
    st.opaque = false
    st.clips_to_bounds = false
    st.hidden = true
    st.content_mode = UIViewContentModeBottomLeft

    st.background_color = color.red
    # TODO test background_image

    st.scale = 1.5
    st.rotation = 45
    st.tint_color = color.blue
    st.layer.cornerRadius = 5
  end

end

shared 'styler' do

  it 'should apply style when a view is created' do
    view = @vc.rmq.append(@view_klass, :my_style).get
    view.origin.x.should == 1
    view.origin.y.should == 2
  end

  it 'should return the view from the styler' do
    view = @vc.rmq.append(@view_klass, :my_style).get
    styler = @vc.rmq.styler_for(view)
    styler.view.should == view
  end

  it 'should return the superview from the styler' do
    view = @vc.rmq.append(@view_klass, :my_style).get
    styler = @vc.rmq.styler_for(view)
    styler.superview.should == view.superview
  end

  it 'should return true if a view has been styled and view_has_been_styled? is called' do
    view = @vc.rmq.append(@view_klass).get
    @vc.rmq.styler_for(view).view_has_been_styled?.should == false
    @vc.rmq(view).apply_style(:my_style)
    @vc.rmq.styler_for(view).view_has_been_styled?.should == true
  end

  it 'should apply a style using the apply_style method' do
    view = @vc.rmq.append(@view_klass).get
    @vc.rmq(view).apply_style(:my_style)
    view.origin.x.should == 1
    view.origin.y.should == 2
  end

  it 'should allow styling by passing a block to the style method' do
    view = @vc.rmq.append(@view_klass).get

    @vc.rmq(view).style do |st|
      st.frame = {l: 4, t: 5, w: 6, h: 7}
      st.background_color = @vc.rmq.color.blue
      st.z_position = 99
    end

    view.origin.x.should == 4
    view.origin.y.should == 5
    view.layer.zPosition.should == 99
  end

  # TODO, test super_height and super_width

  it 'should apply a style with every UIViewStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_view_kitchen_sink).get

    view.tap do |v|
      # TODO check all the values set in ui_view_kitchen_sink
      1.should == 1
    end
  end
end

describe 'ui_view_styler' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UIView
  end

  behaves_like "styler"

  it 'should set frame' do
    view = @vc.rmq.append(@view_klass, :complete_frame).get
    view.frame.origin.x.should == 5
    view.frame.origin.y.should == 10
    view.frame.size.width.should == 20
    view.frame.size.height.should == 30
  end

  it 'should set a real frame' do
    view = @vc.rmq.append(@view_klass, :real_frame).get
    view.frame.origin.x.should == 5
    view.frame.origin.y.should == 10
    view.frame.size.width.should == 20
    view.frame.size.height.should == 30
  end

  it 'should set an array frame' do
    view = @vc.rmq.append(@view_klass, :array_frame).get
    view.frame.origin.x.should == 5
    view.frame.origin.y.should == 10
    view.frame.size.width.should == 20
    view.frame.size.height.should == 30
  end

  it 'should keep existing frame values if not an entire frame is specified' do
    view = @vc.rmq.append(@view_klass).get
    view.frame = [[1,2],[3,4]]
    view.frame.size.width.should == 3

    @vc.rmq(view).apply_style(:partial_frame_size)
    view.frame.origin.x.should == 1
    view.frame.origin.y.should == 2
    view.frame.size.width.should == 20
    view.frame.size.height.should == 30

    view.frame = [[1,2],[3,4]]
    @vc.rmq(view).apply_style(:partial_frame_location)
    view.frame.origin.x.should == 5
    view.frame.origin.y.should == 10
    view.frame.size.width.should == 3
    view.frame.size.height.should == 4
  end

  it 'should set attributes onto the view' do
    view = @vc.rmq.append(@view_klass, :ui_view_kitchen_sink).get
    view.clipsToBounds.should == false
    view.isHidden.should == true
    view.contentMode.should == UIViewContentModeBottomLeft
    view.tintColor.class.should == UIColor.blueColor.class
    view.layer.cornerRadius.should == 5
  end
end
