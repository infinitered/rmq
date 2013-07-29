class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_switch_kitchen_sink(st)
    st.on = st.on
    st.on = true
  end

end

describe 'stylers/ui_switch' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UISwitch
  end

  behaves_like "styler"

  it 'should apply a style with every UISwitchStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_switch_kitchen_sink).get

    view.tap do |v|
      v.isOn.should == true 
    end
  end
end
