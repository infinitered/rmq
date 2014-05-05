describe 'animations' do
  # These are hard to test, mainly I'm just smoke testing here

  before do
    @vc = UIViewController.alloc.init
    @viewq = @vc.rmq.append(UIView)
    UIView.setAnimationsEnabled false
    @sub_viewq = @vc.rmq(@viewq).append(UIView)
  end

  after do
    UIView.setAnimationsEnabled true
  end
  

  it 'should animate' do
    @vc.rmq.animate(
    duration: 0.0,
    animations: -> (rmq) {
      RubyMotionQuery::RMQ.is_blank?(rmq).should == false
    },
    completion: -> (did_finish, rmq) {
      rmq.animate( 
        duration: 0.0,
        animations: -> (rmq) {
          RubyMotionQuery::RMQ.is_blank?(rmq).should == false
        })
    })
  end

  it 'should animate given only a block' do
    @vc.rmq.animate do |q|
      RubyMotionQuery::RMQ.is_blank?(rmq).should == false
    end
  end

  it 'should allow options from animateWithDuration in animate' do
    @vc.rmq.animate(
    duration: 0.0,
    options: UIViewAnimationOptionTransitionNone || UIViewAnimationOptionCurveLinear,
    animations: -> (rmq) {
      RubyMotionQuery::RMQ.is_blank?(rmq).should == false
    })
  end

  it 'should have an set of standard animations' do
    RubyMotionQuery::RMQ.is_blank?(@viewq.animations).should == false
  end

  it 'should fade_in' do
    @viewq.animations.fade_in(duration: 0.0).is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should fade_out' do
    @viewq.animations.fade_out(duration: 0.0).is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should blink' do
    @viewq.animations.fade_in(duration: 0.0).is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should throb' do
    @viewq.animations.throb.is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should drop and spin' do
    @viewq.animations.drop_and_spin.is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should sink and throb' do
    @viewq.animations.sink_and_throb.is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should land, sink, and throb' do
    @viewq.animations.land_and_sink_and_throb.is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should start spinner' do
    q = @vc.rmq.animations.start_spinner
    q.first.get.is_a?(UIActivityIndicatorView).should == true
  end

  it 'should stop spinner' do
    q = @vc.rmq.animations.stop_spinner
    q.first.get.is_a?(UIActivityIndicatorView).should == true
  end
end
