class StyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet

  def u_image_view_kitchen_sink(st)
    st.image = image.resource('logo')
  end

end

describe 'stylers/ui_image_view' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForUIViewStylerTests
    @view_klass = UIImageView 
  end

  behaves_like "styler"

  it 'should apply a style with every UIImageViewStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :u_image_view_kitchen_sink).get

    view.image.should == @vc.rmq.image.resource('logo')
  end
end
