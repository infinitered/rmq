class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_table_view_cell_kitchen_sink(st)
    st.text_color = rmq.color.red
    st.font = rmq.font.system(11)
    st.selection_style = UITableViewCellSelectionStyleBlue
  end
end

describe 'stylers/ui_table_view_cell' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UITableViewCell
  end

  behaves_like "styler"

  it 'should apply a style with every UITableViewCell wrapper method' do
    view = @vc.rmq.create!(@view_klass, :ui_table_view_cell_kitchen_sink)
    view.tap do |v|
      view.textLabel.textColor.should.equal(rmq.color.red)
      view.textLabel.font.should.equal(rmq.font.system(11))
      view.selectionStyle.should.equal(UITableViewCellSelectionStyleBlue)
    end
  end
end
