class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_button_kitchen_sink(st)
    st.text = 'foo'
    st.font = font.system(12)
    st.color = color.red
    st.image_normal = image.resource('logo')
    st.image_highlighted = image.resource('logo')
  end

end

describe 'stylers/ui_button' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = SyleSheetForUIViewStylerTests
    @view_klass = UIButton
  end

  behaves_like "styler"

  it 'should apply a style with every UIButtonStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_button_kitchen_sink).get

    view.tap do |v|
      # TODO
      1.should == 1
    end
  end
end
