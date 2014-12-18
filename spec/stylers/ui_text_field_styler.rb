describe 'stylers/ui_text_field' do
  class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet
    def ui_text_field_kitchen_sink(st)
      st.text = 'foo'
      st.text_alignment = :center
      st.placeholder = "placeholder"
      st.border_style = UITextBorderStyleRoundedRect
      st.autocapitalization_type = UITextAutocapitalizationTypeWords
      st.keyboard_type = UIKeyboardTypeDefault
    end

    def ui_text_field_email(st)
      st.keyboard_type = :email_address
    end
  end

  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UITextField
  end

  behaves_like "styler"

  it 'should apply a style with every UITextFieldStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_text_field_kitchen_sink).get

    view.tap do |v|
      v.text.should == 'foo'
      v.textAlignment.should  == NSTextAlignmentCenter
      v.placeholder.should == "placeholder"
      v.borderStyle.should == UITextBorderStyleRoundedRect
      v.autocapitalizationType.should == UITextAutocapitalizationTypeWords
      v.keyboardType.should == UIKeyboardTypeDefault
    end
  end

  it 'should allow setting a keyboard type via symbol' do
    view = @vc.rmq.append(@view_klass, :ui_text_field_email).get
    view.keyboardType.should == UIKeyboardTypeEmailAddress
  end
end
