describe 'position' do
  before do
    @vc = UIViewController.alloc.init
  end

  it 'should move a view' do
    view = @vc.rmq.append(UIView).get
    view.origin.x.should == 0
    @vc.rmq(view).move l: 30
    view.origin.x.should == 30
  end

  it 'should move and resize multiple views' do

    view = @vc.rmq.append(UIView).get
    view2 = @vc.rmq.append(UIView).get
    view3 = @vc.rmq.append(UIView).get

    @vc.rmq.all.append(UIButton)

    @vc.rmq(UIButton).each do |button|
      button.origin.x.should == 0
    end

    @vc.rmq(UIButton).move(l: 10, t: 20, w: 30, h: 40)
    @vc.rmq(UIButton).each do |button|
      button.origin.x.should == 10
      button.origin.y.should == 20
      button.size.width.should == 30 
      button.size.height.should == 40
    end

    @vc.rmq(UIButton).resize(left: 50, y: 60, width: 70, height: 80)
    @vc.rmq(UIButton).each do |button|
      button.origin.x.should == 50
      button.origin.y.should == 60
      button.size.width.should == 70
      button.size.height.should == 80
    end
  end

  it 'should align multiple views with each other' do
    1.should == 1
    # TODO
  end

  it 'should nudge a view in various directions' do
    view = @vc.rmq.append(UILabel).get
    view.origin.x.should == 0
    @vc.rmq(view).nudge r: 10
    view.origin.x.should == 10 

    @vc.rmq(view).nudge l: 8, d: 1, u: 1 
    view.origin.x.should == 2
    view.origin.y.should == 0

    @vc.rmq(view).nudge left: 10, right: 80, down: 100, up: 10
    view.origin.x.should == 72
    view.origin.y.should == 90 
  end

end
