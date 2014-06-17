describe 'actions' do
  before do
    @vc = UIViewController.alloc.init
    @viewq = @vc.rmq.append(UIView)
    @sub_viewq = @viewq.append(UIView)
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

  describe 'focus' do
    before do
      window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)
      @vc = UIViewController.alloc.initWithNibName(nil, bundle: nil)
      window.rootViewController = @vc
      window.makeKeyAndVisible

      @tf_0 = @vc.rmq.append(UITextField).style do |st|
        st.frame = {l: 10, t: 10, w: 100, h: 30}
      end.get
      @tf_1 = @vc.rmq.append(UITextField).style do |st|
        st.frame = {l: 10, t: 50, w: 100, h: 30}
      end.get
    end

    it 'should set focus to a selected view' do
      @tf_1.becomeFirstResponder.should == true
      @tf_1.isFirstResponder.should == true
      @tf_0.isFirstResponder.should == false

      @vc.rmq(@tf_0).focus.is_a?(RubyMotionQuery::RMQ).should == true
      @tf_1.isFirstResponder.should == false
      @tf_0.isFirstResponder.should == true
    end

    it 'should focus only the last selected view, if many views are selected' do
      @tf_0.becomeFirstResponder.should == true
      @tf_1.isFirstResponder.should == false
      @tf_0.isFirstResponder.should == true
      @vc.rmq(@tf_0, @tf_1).become_first_responder
      @tf_1.isFirstResponder.should == true
      @tf_0.isFirstResponder.should == false
    end
  end

  it 'should set attributes on a view' do
    label = UILabel.alloc.init
    label.text = "not modified"
    @vc.rmq.append(label)
    @vc.rmq(UILabel).attr({text: "updated"})
    label.text.should == "updated"
  end

  it 'should set attributes on multiple views' do
    labels = [ UILabel.alloc.init, UILabel.alloc.init, UILabel.alloc.init]
    labels.each { |label| @vc.rmq.append(label) }
    @vc.rmq(UILabel).attr({text: "updated"})
    labels.each { |label| label.text.should == "updated" }
  end

  it 'should call method on a view' do
    label = UILabel.alloc.init
    label.text = "not modified"
    @vc.rmq.append(label)
    label.frame.size.width.should == 0
    @vc.rmq(UILabel).send("sizeToFit")
    label.frame.size.width.should.not == 0
  end

  it 'should call method  on multiple views' do
    labels = [ UILabel.alloc.init, UILabel.alloc.init, UILabel.alloc.init]
    labels.each do |label|
      label.text = "something to make it need a width"
      @vc.rmq.append(label)
    end

    @vc.rmq(UILabel).send("sizeToFit")
    labels.each { |label| label.frame.size.width.should.not == 0 }
  end

  it 'should call method  on multiple views, ignoring any that do not implement the method' do
    labels = [ UILabel.alloc.init, UILabel.alloc.init, UIView.alloc.init]
    should.not.raise(NoMethodError) do
      @vc.rmq(UIView).send("highlighted")
    end
  end

  it 'should read and set data for UILabel' do
    rmq.create(UILabel).data('foo').get.text.should == 'foo'
    rmq.create(UILabel).data('bar').data.should == 'bar'
  end

  it 'should read and set data for UIButton' do
    rmq.create(UIButton).data('foo').get.titleForState(UIControlStateNormal).should == 'foo'
    rmq.create(UIButton).data('bar').data.should == 'bar'
  end

  it 'should read and set data for UIImageView' do
    image = rmq.image.resource('logo')
    rmq.create(UIImageView).data(image).get.image.should == image
    rmq.create(UIImageView).data(image).data.should == image
  end

  it 'should read and set data for UITextView' do
    rmq.create(UITextView).data('foo').get.text.should == 'foo'
    rmq.create(UITextView).data('bar').data.should == 'bar'
  end

  it 'should read and set data for UITextField' do
    rmq.create(UITextField).data('foo').get.text.should == 'foo'
    rmq.create(UITextField).data('bar').data.should == 'bar'
  end
end
