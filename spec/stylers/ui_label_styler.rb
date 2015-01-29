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
    st.line_break_mode = NSLineBreakByWordWrapping
  end

  def ui_label_attributed_string(st)
    st.attributed_text = NSAttributedString.alloc.initWithString("RMQ")
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
      v.font.should == UIFont.systemFontOfSize(12)
      v.color.should == UIColor.blackColor
      v.textAlignment.should == NSTextAlignmentCenter
      v.adjustsFontSizeToFitWidth.should == true
      v.size.width.should > 0
      v.numberOfLines.should == 0
      v.lineBreakMode.should == NSLineBreakByWordWrapping
    end

  end

  it "applies an attributed string" do
    view = @vc.rmq.append(@view_klass, :ui_label_attributed_string).get

    view.tap do |v|
      v.text.should == 'RMQ'
    end
  end
end

