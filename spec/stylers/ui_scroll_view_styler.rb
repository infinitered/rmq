class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_scroll_view_kitchen_sink(st)
    st.paging = st.paging
    st.paging = true

    st.scroll_enabled = st.scroll_enabled
    st.scroll_enabled = false

    st.direction_lock = st.direction_lock
    st.direction_lock = true
  end

end

describe 'stylers/ui_scroll_view' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UIScrollView
  end

  behaves_like "styler"

  it 'should apply a style with every UIScrollViewStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_scroll_view_kitchen_sink).get

    view.tap do |v|
      v.isPagingEnabled.should == true
      v.isScrollEnabled.should == false
      v.isDirectionalLockEnabled.should == true
    end
  end
end
