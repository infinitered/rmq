class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_table_view_cell_kitchen_sink(st)
    st.text_color = rmq.color.red
    st.font = rmq.font.system(15)
    st.selection_style = UITableViewCellSelectionStyleBlue
    st.detail_text_color = rmq.color.green
    st.detail_font = rmq.font.system(11)
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
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleSubtitle, reuseIdentifier: "test-cell")
    @vc.rmq(cell).apply_style(:ui_table_view_cell_kitchen_sink)
    cell.tap do |c|
      c.textLabel.textColor.should.equal(rmq.color.red)
      c.textLabel.font.should.equal(rmq.font.system(15))
      c.selectionStyle.should.equal(UITableViewCellSelectionStyleBlue)
      c.detailTextLabel.textColor.should.equal(rmq.color.green)
      c.detailTextLabel.font.should.equal(rmq.font.system(11))
    end

    @vc.rmq(cell).style do |st|
      st.text_color.should.equal(rmq.color.red)
      st.detail_text_color.should.equal(rmq.color.green)
      st.font.should.equal(rmq.font.system(15))
      st.detail_font.should.equal(rmq.font.system(11))
    end
  end

  it 'should not raise if the cell does not have a detail label' do
    cell = UITableViewCell.alloc.initWithStyle(UITableViewCellStyleDefault, reuseIdentifier: "default-cell")

    should.not.raise(NoMethodError) do
      @vc.rmq(cell).apply_style(:ui_table_view_cell_kitchen_sink)
    end
  end
end
