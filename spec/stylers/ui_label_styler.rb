class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_label_kitchen_sink(st)
    st.text = 'rmq is awesome'
    st.font = font.system(12)
    st.color = color.black
    st.text_alignment = :center
    st.number_of_lines = :unlimited
    st.adjusts_font_size = true
    st.resize_to_fit_text
    st.size_to_fit
  end

end

describe 'stylers/ui_label' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UILabel
  end

  behaves_like "styler"

  it 'should apply a style with every UILabelStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_label_kitchen_sink).get

    view.tap do |v|
      v.text.should == 'rmq is awesome'
      v.font = UIFont.systemFontOfSize(12)
      v.color = UIColor.blackColor
      v.textAlignment = NSTextAlignmentCenter
      v.adjustsFontSizeToFitWidth.should == true
      v.size.width.should > 0
      v.numberOfLines.should == 0
    end
  end

end

