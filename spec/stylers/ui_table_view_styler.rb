class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_table_view_kitchen_sink(st)
    st.separator_style = st.separator_style
    st.separator_style = :none

    st.separator_color = st.separator_color
    st.separator_color = UIColor.redColor

    st.allows_selection = st.allows_selection
    st.allows_selection = false
  end

end

describe 'stylers/ui_table_view' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UITableView
  end

  behaves_like "styler"

  it 'should apply a style with every UITableViewStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_table_view_kitchen_sink).get

    view.tap do |v|
      v.separatorStyle.should == UITableViewCellSeparatorStyleNone
      v.separatorColor.should == UIColor.redColor
      v.allowsSelection.should == false
    end
  end
end
