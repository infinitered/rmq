class SyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def ui_control_kitchen_sink(st)
    # TODO
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
      # TODO
      1.should == 1
    end
  end
end
