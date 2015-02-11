class StyleSheetForUIViewStylerTests < RubyMotionQuery::Stylesheet
  def ui_progress_view_tints(st)
    st.progress_tint_color = UIColor.redColor
    st.track_tint_color = UIColor.blueColor
    st.progress_view_style = UIProgressViewStyleBar
  end

  # Tint properties are ignored when using images so we must test them separately
  def ui_progress_view_images(st)
    st.progress_image = image.resource('logo')
    st.track_image = image.resource('logo')
  end
end

describe 'stylers/ui_progress_view' do
  before do
    @vc = UIViewController.alloc.init
    @vc.rmq.stylesheet = StyleSheetForUIViewStylerTests
    @view_klass = UIProgressView.alloc.initWithProgressViewStyle(UIProgressViewStyleDefault)
  end

  behaves_like "styler"

  it 'should apply a style with every UIProgressViewStyler wrapper method' do
    view = @vc.rmq.append(@view_klass, :ui_progress_view_tints).get
    view.tap do |v|
      v.progressTintColor.should == UIColor.redColor
      v.trackTintColor.should == UIColor.blueColor
      v.progressViewStyle.should == UIProgressViewStyleBar
    end

    view = @vc.rmq.append(@view_klass, :ui_progress_view_images).get
    view.tap do |v|
      v.progressImage.should == @vc.rmq.image.resource('logo')
      v.trackImage.should == @vc.rmq.image.resource('logo')
    end
  end
end
