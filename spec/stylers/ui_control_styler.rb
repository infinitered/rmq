class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_control_kitchen_sink(st)
    st.content_vertical_alignment = UIControlContentVerticalAlignmentFill
    st.content_horizontal_alignment = UIControlContentHorizontalAlignmentFill
    st.selected = true
    st.highlighted = true
  end

end

describe 'stylers/control' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UIControl
  end

  behaves_like "styler"

  it 'should apply a style with every UIControlStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_control_kitchen_sink).get

    view.tap do |v|
      v.contentVerticalAlignment.should == UIControlContentVerticalAlignmentFill
      v.contentHorizontalAlignment.should == UIControlContentHorizontalAlignmentFill
      v.isSelected.should.be.true
      v.isHighlighted.should.be.true
      v.selected = false
      v.highlighted = false
    end
  end

  it 'should return proper values from the getter styles also' do
    view = @vc.rmq.append!(@view_klass, :ui_control_kitchen_sink)

    @vc.rmq(view).style do |st|
      st.selected.should.be.true
      st.highlighted.should.be.true
      st.content_vertical_alignment.should == UIControlContentVerticalAlignmentFill
      st.content_horizontal_alignment.should == UIControlContentHorizontalAlignmentFill

      st.state.should == (UIControlStateSelected | UIControlStateHighlighted)
    end
  end
end
