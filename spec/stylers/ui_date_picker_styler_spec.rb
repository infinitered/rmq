class StyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_date_picker_kitchen_sink(st)
    st.date_picker_mode = :date_time
  end
end

describe 'stylers/ui_date_picker' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForUIViewStylerTests
    @view_klass = UIDatePicker
  end

  #fails for some reason
  #behaves_like "styler"

  it 'can update picker with styler' do
    view = @vc.rmq.append(@view_klass, :ui_date_picker_kitchen_sink).get

    view.tap do |v|
      v.datePickerMode.should == UIDatePickerModeDateAndTime
    end
  end
end
