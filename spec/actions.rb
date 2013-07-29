describe 'actions' do
  before do
    @vc = UIViewController.alloc.init
    @viewq = @vc.rmq.append(UIView)
    @sub_viewq = @vc.rmq(@viewq).append(UIView)
  end

  it 'should hide, show, and toggle a view' do
    @viewq.get.hidden?.should == false
    @viewq.hide
    @viewq.get.hidden?.should == true
    @viewq.show
    @viewq.get.hidden?.should == false
    @viewq.toggle
    @viewq.get.hidden?.should == true
    @viewq.toggle
    @viewq.get.hidden?.should == false
  end

  it 'should hide, show, and toggle multiple views' do
    @vc.rmq.all.tap do |q|
      q.each { |view| view.hidden?.should == false }
      q.hide
      q.each { |view| view.hidden?.should == true }

      q.show
      q.each { |view| view.hidden?.should == false }

      q.toggle
      q.each { |view| view.hidden?.should == true }

      q.toggle
      q.each { |view| view.hidden?.should == false }
    end
  end

  it 'should toggle enabled on a view' do
    @viewq.get.enabled?.should == true
    @viewq.toggle_enabled
    @viewq.get.enabled?.should == false
    @viewq.toggle_enabled
    @viewq.get.enabled?.should == true
  end

  it 'should toggle enabled on multiple views' do
    @vc.rmq.all.tap do |q|
      q.each { |view| view.enabled?.should == true }
      q.toggle_enabled
      q.each { |view| view.enabled?.should == false }
      q.toggle_enabled
      q.each { |view| view.enabled?.should == true }
    end
  end

  it 'should set attributes on a view' do
    1.should == 1
    # TODO
  end

  it 'should set attributes on multiple views' do
    1.should == 1
    # TODO
  end

  it 'should call method on a view' do
    1.should == 1
    # TODO
  end

  it 'should call method  on multiple views' do
    1.should == 1
    # TODO
  end

end
