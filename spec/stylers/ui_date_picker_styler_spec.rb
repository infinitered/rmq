class StyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_date_picker_kitchen_sink(st)
    st.date_picker_mode = :date_and_time
  end

  def ui_date_picker_time(st)
    st.date_picker_mode = :time
  end

  def ui_date_picker_date(st)
    st.date_picker_mode = :date
  end

  def ui_date_picker_date_time_alias(st)
    st.date_picker_mode = :date_time
  end

  def ui_date_picker_count_down_timer(st)
    st.date_picker_mode = :count_down_timer
  end

  def ui_date_picker_countdown_alias(st)
    st.date_picker_mode = :countdown
  end

  def ui_date_picker_count_down_alias(st)
    st.date_picker_mode = :count_down
  end
end

describe 'stylers/ui_date_picker' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForUIViewStylerTests
    @view_klass = UIDatePicker
  end

  behaves_like "styler"

  it 'can update picker with styler' do
    view = @vc.rmq.append(@view_klass, :ui_date_picker_kitchen_sink).get

    view.tap do |v|
      v.datePickerMode.should == UIDatePickerModeDateAndTime
    end
  end

  it 'can update picker with :time styler' do
    view = @vc.rmq.append(@view_klass, :ui_date_picker_time).get

    view.tap do |v|
      v.datePickerMode.should == UIDatePickerModeTime
    end
  end

  it 'can update picker with :date styler' do
    view = @vc.rmq.append(@view_klass, :ui_date_picker_date).get

    view.tap do |v|
      v.datePickerMode.should == UIDatePickerModeDate
    end
  end

  it 'uses :date_time as an alias for :date_and_time' do
    view = @vc.rmq.append(@view_klass, :ui_date_picker_date_time_alias).get

    view.tap do |v|
      v.datePickerMode.should == UIDatePickerModeDateAndTime
    end
  end

  it 'can update picker with :count_down_timer styler' do
    view = @vc.rmq.append(@view_klass, :ui_date_picker_count_down_timer).get

    view.tap do |v|
      v.datePickerMode.should == UIDatePickerModeCountDownTimer
    end
  end

  it 'uses :count_down as an alias for :count_down_timer' do
    view = @vc.rmq.append(@view_klass, :ui_date_picker_count_down_alias).get

    view.tap do |v|
      v.datePickerMode.should == UIDatePickerModeCountDownTimer
    end
  end
end
