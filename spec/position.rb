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

  it 'resize and layout should alias move' do
    view = @vc.rmq.append(UIView).get
    view.origin.x.should == 0
    @vc.rmq(view).layout(l: 40, t: 5, w: 10, h: 10)
    view.origin.x.should == 40
    view.origin.y.should == 5

    @vc.rmq(view).resize(width: 50, height: 20)
    view.size.width.should == 50
    view.size.height.should == 20
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

  it 'should distribute horizontally with margin set' do
    q = @vc.rmq
    a = q.append(UIView).layout(l: 5, t: 0, w: 10, h: 30).get
    b = q.append(UIButton).layout(l: 120, t: 20, w: 70, h: 10).get
    c = q.append(UILabel).layout(l: 22, t: 12, w: 0, h: 0).get
    d = q.append(UILabel).layout(l: 60, t: 10, w: 40, h: 20).get

    @vc.rmq(a, b, c, d).distribute(:horizontal, margin: 6)
    a.rmq.frame.left.should == 5
    b.rmq.frame.left.should == a.rmq.frame.right + 6
    c.rmq.frame.left.should == b.rmq.frame.right + 6
    d.rmq.frame.left.should == c.rmq.frame.right + 6
  end

  it 'should distribute vertically with margin set' do
    q = @vc.rmq

    a = q.append(UIView).layout(l: 5, t: 0, w: 10, h: 30).get
    b = q.append(UIButton).layout(l: 120, t: 20, w: 70, h: 10).get
    c = q.append(UILabel).layout(l: 22, t: 12, w: 0, h: 0).get
    d = q.append(UILabel).layout(l: 60, t: 10, w: 40, h: 20).get

    @vc.rmq(a, b, c, d).distribute(:vertical, margin: 7)
    a.rmq.frame.top.should == 0
    b.rmq.frame.top.should == 30 + 7
    c.rmq.frame.top.should == (30 + 7) + 10 + 7
    d.rmq.frame.top.should == ((30 + 7) + 10 + 7) + 7
  end

  it 'should distribute vertically by default' do
    q = @vc.rmq

    a = q.append(UIView).layout(l: 5, t: 0, w: 10, h: 30).get
    b = q.append(UIButton).layout(l: 120, t: 20, w: 70, h: 10).get
    c = q.append(UILabel).layout(l: 22, t: 12, w: 0, h: 0).get
    d = q.append(UILabel).layout(l: 60, t: 10, w: 40, h: 20).get

    @vc.rmq(a, b, c, d).distribute
    a.rmq.frame.top.should == 0
    b.rmq.frame.top.should == 30
    c.rmq.frame.top.should == 30 + 10
    d.rmq.frame.top.should == 30 + 10
  end

  # TODO test distribute with [5,5,10,5,10,5,10,20]

  it 'should resize to fit subviews by making the view smaller' do
    view = @vc.rmq.append(UIView).layout(h: 100, w: 20).get
    view.rmq.append(UIButton).layout(h: 50, w: 10)
    view.rmq.append(UIButton).layout(h: 5, w: 1)
    view.size.width.should == 20
    view.rmq.resize_to_fit_subviews
    view.size.width.should == 10
    view.size.height.should == 50
  end

  it 'should resize to fit subviews by making the view larger' do
    view = @vc.rmq.append(UIView).layout(h: 100, w: 20).get
    view.rmq.append(UIButton).layout(h: 50, w: 10)
    view.rmq.append(UILabel).layout(h: 500, w: 70)
    view.rmq.append(UIView).layout(h: 5, w: 1)
    view.size.width.should == 20
    view.size.height.should == 100
    view.rmq.resize_to_fit_subviews
    view.size.width.should == 70
    view.size.height.should == 500
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

  it 'should give location of a view within the root view' do
    view = @vc.rmq.append(UIView).move(l: 10, t: 20, w: 30, h: 40).get
    @vc.rmq(view).location_in_root_view.should == CGPoint.new(10, 20)

    view_2 = @vc.rmq(view).append(UIView).move(l: 10, t: 20, w: 5, h: 5).get
    view_2.origin.should == CGPoint.new(10, 20)
    @vc.rmq(view_2).location_in_root_view.should == CGPoint.new(20, 40)
  end

  it 'should give location of a views (as an array) within the root view' do
    view = @vc.rmq.append(UIView).move(l: 10, t: 20, w: 30, h: 40).get
    view_2 = @vc.rmq(view).append(UIView).move(l: 10, t: 20, w: 5, h: 5).get

    @vc.rmq(view, view_2).location_in_root_view.should == [CGPoint.new(10, 20),CGPoint.new(20, 40)]
  end
end
