describe 'stylers/ui_text_field' do
  class StyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet
    def ui_text_field_kitchen_sink(st)
      st.text = 'foo'
      st.color = color.red
      st.text_alignment = :center
      st.placeholder = "placeholder"
      st.border_style = UITextBorderStyleRoundedRect
      st.autocapitalization_type = :words
      st.autocorrection_type = :no
      st.keyboard_type = UIKeyboardTypeDefault
      st.keyboard_appearance = UIKeyboardAppearanceDark
      st.return_key_type = UIReturnKeyNext
      st.spell_checking_type = UITextSpellCheckingTypeYes
      st.right_view_mode = :always
      st.adjusts_font_size_to_fit_width = true
    end

    def ui_text_field_color(st)
      st.text_color = color.blue
    end

    def ui_text_field_email(st)
      st.keyboard_type = :email_address
    end

    def ui_text_field_alert(st)
      st.keyboard_appearance = :alert
    end

    def ui_text_field_google(st)
      st.return_key_type = :google
    end

    def ui_text_field_no_spell_check(st)
      st.spell_checking_type = :no
    end

    def ui_text_field_line_border(st)
      st.border_style = :line
    end

    def ui_text_field_right_mode(st)
      st.right_view_mode = UITextFieldViewModeUnlessEditing
    end

    def ui_text_field_left_mode(st)
      st.left_view_mode = :while_editing
    end
  end

  before do
    @vc = UIViewController.new
    @vc.rmq.stylesheet = StyleSheetForUIViewStylerTests
    @view_klass = UITextField
  end

  behaves_like "styler"

  it 'should apply a style with every UITextFieldStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_text_field_kitchen_sink).get

    view.tap do |v|
      v.text.should == 'foo'
      v.textColor.should == rmq.color.red
      v.textAlignment.should  == NSTextAlignmentCenter
      v.placeholder.should == "placeholder"
      v.borderStyle.should == UITextBorderStyleRoundedRect
      v.autocapitalizationType.should == UITextAutocapitalizationTypeWords
      v.autocorrectionType == UITextAutocorrectionTypeNo
      v.keyboardType.should == UIKeyboardTypeDefault
      v.keyboardAppearance.should == UIKeyboardAppearanceDark
      v.returnKeyType.should == UIReturnKeyNext
      v.spellCheckingType.should == UITextSpellCheckingTypeYes
      v.rightViewMode.should == UITextFieldViewModeAlways
      v.adjustsFontSizeToFitWidth.should == true
    end
  end

  it 'allows adjusts_font_size alias' do
    view = @vc.rmq.append(@view_klass, :ui_text_field_kitchen_sink)
    view.style do |st|
      st.adjusts_font_size_to_fit_width.should == true

      st.adjusts_font_size = false

      st.adjusts_font_size.should == false
      st.adjusts_font_size_to_fit_width.should == false
    end
  end

  it 'allows color set with `text_color`' do
    view = @vc.rmq.append!(@view_klass, :ui_text_field_color)
    view.textColor.should == rmq.color.blue
  end

  it 'should allow setting a keyboard type via symbol' do
    view = @vc.rmq.append(@view_klass, :ui_text_field_email).get
    view.keyboardType.should == UIKeyboardTypeEmailAddress
  end

  it 'should allow setting a keyboard appearance via symbol' do
    view = @vc.rmq.append(@view_klass, :ui_text_field_alert).get
    view.keyboardAppearance.should == UIKeyboardAppearanceAlert
  end

  it 'should allow setting a return key via symbol' do
    view = @vc.rmq.append(@view_klass, :ui_text_field_google).get
    view.returnKeyType.should == UIReturnKeyGoogle
  end

  it 'should allow setting a spell checking type via symbol' do
    view = @vc.rmq.append(@view_klass, :ui_text_field_no_spell_check).get
    view.spellCheckingType.should == UITextSpellCheckingTypeNo
  end

  it 'should allow setting a border style via symbol' do
    view = @vc.rmq.append(@view_klass, :ui_text_field_line_border).get
    view.borderStyle.should == UITextBorderStyleLine
  end

  it 'allows setting right and left view modes with and without symbols' do
    view1 = @vc.rmq.append(@view_klass, :ui_text_field_right_mode).get
    view1.rightViewMode.should == UITextFieldViewModeUnlessEditing
    view2 = @vc.rmq.append(@view_klass, :ui_text_field_left_mode).get
    view2.leftViewMode.should == UITextFieldViewModeWhileEditing
  end
end
