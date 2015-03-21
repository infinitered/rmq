class StyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_table_view_kitchen_sink(st)
    st.separator_style = st.separator_style
    st.separator_style = :none

    st.separator_color = st.separator_color
    st.separator_color = UIColor.redColor

    st.separator_inset = [0, 46, 0, 0]

    st.allows_selection = st.allows_selection
    st.allows_selection = false
    st.row_height = 20
  end

  def ui_table_view_background_image(st)
    ui_table_view_kitchen_sink(st)
    st.background_image = rmq.image.resource("Default")
  end

end

describe 'stylers/ui_table_view' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForUIViewStylerTests
    @view_klass = UITableView
  end

  behaves_like "styler"

  it 'should apply a style with every UITableViewStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_table_view_kitchen_sink).get

    view.tap do |v|
      v.separatorStyle.should == UITableViewCellSeparatorStyleNone
      v.separatorColor.should == UIColor.redColor
      v.allowsSelection.should == false
      v.separatorInset.should == UIEdgeInsetsMake(0, 46, 0, 0)
      v.rowHeight.should == 20
    end
  end

  it 'should allow getting and setting the background image' do

    view = @vc.rmq.append(@view_klass, :ui_table_view_kitchen_sink)

    view.style do |st|
      st.background_image.should == nil
      background = rmq.image.resource("Default")
      st.background_image = background
      st.background_image.should == background
    end
  end

  it 'should allow setting a background color when there is a background image' do
    view = @vc.rmq.append(@view_klass, :ui_table_view_background_image)

    view.style do |st|
      st.background_image.should == rmq.image.resource("Default")
      st.background_color = rmq.color.red
      st.background_image.should == nil
      st.background_color.should == rmq.color.red
    end

  end
end
