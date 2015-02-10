class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet
  def ui_page_control_kitchen_sink(st)
    st.number_of_pages = 4
    st.current_page = 2
    st.page_indicator_tint_color = color.green
    st.current_page_indicator_tint_color = color.red
  end
end

describe 'stylers/ui_page_control_styler' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UIPageControl
  end

  behaves_like "styler"

  it 'should apply a style with every UIPageControl wrapper method' do
    view = @vc.rmq.append!(@view_klass, :ui_page_control_kitchen_sink)

    view.tap do |v|
      v.numberOfPages.should.equal(4)
      v.currentPage.should.equal(2)
      v.pageIndicatorTintColor.should.equal(rmq.color.green)
      v.currentPageIndicatorTintColor.should.equal(rmq.color.red)
    end

    rmq(view).style do |st|
      st.number_of_pages.should.equal(4)
      st.current_page.should.equal(2)
      st.page_indicator_tint_color.should.equal(rmq.color.green)
      st.current_page_indicator_tint_color.should.equal(rmq.color.red)
    end
  end
end
