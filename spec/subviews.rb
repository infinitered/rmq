describe 'subviews' do
  before do
    @vc = UIViewController.alloc.init
  end

  it 'should append view to a controller' do
    view = @vc.rmq.append(UIView).get
    @vc.view.subviews.length.should == 1
    @vc.view.subviews.first.should == view
  end

  it 'should append view to another view' do
    view = @vc.rmq.append(UIView).get
    label = @vc.rmq(view).append(UILabel).get
    view.subviews.length.should == 1
    view.subviews.first.should == label
  end

  it 'should append a new view to multiple existing views' do
    view = @vc.rmq.append(UIView).get
    view2 = @vc.rmq.append(UIView).get
    view3 = @vc.rmq.append(UIView).get

    added_rmq = @vc.rmq.all.append(UIView)
    @vc.rmq.all.length.should == 6
    view.subviews.length.should == 1
    added_rmq.get.include?(view.subviews.first).should == true
  end

  it 'should append view and assign style_name' do
    @vc.rmq.stylesheet = SyleSheetForSubviewsTests
    view = @vc.rmq.append(UIButton, :my_style).get
    view2 = @vc.rmq.append(UIButton).get
    view.rmq_data.style_name.should == :my_style
    view2.rmq_data.style_name.nil?.should == true
  end

  it 'should remove view from controller' do
    view = @vc.rmq.append(UIView).get
    label = @vc.rmq.append(UILabel).get
    image = @vc.rmq.append(UIImageView).get

    @vc.rmq(UILabel, UIImageView).remove
    @vc.view.subviews.length.should == 1
    @vc.view.subviews.first.should == view
  end

  it 'should remove view from superview' do
    view = @vc.rmq.append(UIView).get
    label = @vc.rmq(view).append(UILabel).get
    image = @vc.rmq(view).append(UIImageView).get

    @vc.rmq(view).children(UIImageView).remove
    view.subviews.length.should == 1
    view.subviews.first.should == label

    @vc.view.subviews.length.should == 1
    @vc.view.subviews.first.should == view
  end

  it 'should insert view to the beginning of a view\'s subviews' do
    1.should == 1
    #TODO
  end
end

class SyleSheetForSubviewsTests < RubyMotionQuery::Stylesheet
  def my_style(st)
  end
end
