class StyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_activity_indicator_view_kitchen_sink(st)
    st.hides_when_stopped = true
    st.activity_indicator_style = :gray
    st.color = color.blue
  end

end

describe 'stylers/ui_activity_indicator_view' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForUIViewStylerTests
    @view_klass = UIActivityIndicatorView
  end

  behaves_like "styler"

  it 'should apply a style with every UIImageViewStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_activity_indicator_view_kitchen_sink).get

    view.hidesWhenStopped.should == true
    view.activityIndicatorViewStyle.should == UIActivityIndicatorViewStyleGray
    view.color.should == rmq.color.blue
  end

  it 'should start and stop animations from the styler' do
    view = @vc.rmq.append(@view_klass, :ui_activity_indicator_view_kitchen_sink)

    view.style do |st|
      st.is_animating?.should == false
      st.start_animating
      st.is_animating?.should == true
      st.stop_animating
      st.is_animating?.should == false

    end
  end

  it 'should start and stop animations from a direct action' do
    view = @vc.rmq.append(@view_klass, :ui_activity_indicator_view_kitchen_sink)

    view.get.isAnimating.should == false
    view.start_animating
    view.get.isAnimating.should == true
    view.stop_animating
    view.get.isAnimating.should == false
  end

end
