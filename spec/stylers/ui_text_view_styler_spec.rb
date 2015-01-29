describe 'stylers/ui_text_view' do
  class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet
    def ui_text_view_kitchen_sink(st)
      st.text = 'foo'
      st.font = font.system(12)
      st.text_alignment = :center
      st.text_color = color.red
      st.editable = true
      st.selectable = true
      st.
      st.data_detector_types = :all
    end

    def ui_text_view_attributed_string(st)
      st.attributed_text = NSAttributedString.alloc.initWithString("RMQ")
    end
  end

  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UITextView
  end

  behaves_like "styler"

  it 'should apply a style with every UITextViewStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_text_view_kitchen_sink).get

    view.tap do |v|
      view.text.should == "foo"
      view.font.should == UIFont.systemFontOfSize(12)
      view.textColor.should == UIColor.redColor
      view.textAlignment.should == NSTextAlignmentCenter
      view.isEditable.should == true
      view.isSelectable.should == true
      view.dataDetectorTypes.should == UIDataDetectorTypeAll
    end
  end

  it "applies an attributed string" do
    view = @vc.rmq.append(@view_klass, :ui_text_view_attributed_string).get

    view.tap do |v|
      v.text.should == 'RMQ'
    end
  end

  it "can also set the color using the 'color' alias" do
    view = @vc.rmq.append(@view_klass, :ui_text_view_kitchen_sink).get

    rmq(view).style do |st|
      st.color = rmq.color.green
    end

    view.tap do |v|
      view.textColor.should == UIColor.greenColor
    end
  end
end
