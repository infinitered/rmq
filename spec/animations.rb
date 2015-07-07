class RubyMotionQuery::Animations
  class << self
    def clear_spinner_class_value
      @_window_spinner = nil
    end
  end
end

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
    RubyMotionQuery::Animations.clear_spinner_class_value
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

  it 'should slide in' do
    @viewq.animations.slide_in.is_a?(RubyMotionQuery::RMQ).should == true
  end

  it 'should slide out' do
    @viewq.animations.slide_out.is_a?(RubyMotionQuery::RMQ).should == true
  end

  describe ".start_spinner" do
    it 'should set the spinner' do
      q = @vc.rmq.animations.start_spinner
      q.first.get.is_a?(UIActivityIndicatorView).should == true
    end

    it 'should default style to UIActivityIndicatorViewStyleGray' do
      q = @vc.rmq.animations.start_spinner
      q.last.get.activityIndicatorViewStyle.should == UIActivityIndicatorViewStyleGray
    end

    it 'should set the view style from the style value' do
      q = @vc.rmq.animations.start_spinner(UIActivityIndicatorViewStyleWhiteLarge)
      q.last.get.activityIndicatorViewStyle.should == UIActivityIndicatorViewStyleWhiteLarge
    end

    it 'should override the style value if both a style and an options style is provided' do
      q = @vc.rmq.animations.start_spinner(UIActivityIndicatorViewStyleWhiteLarge, { style: UIActivityIndicatorViewStyleWhite })
      q.last.get.activityIndicatorViewStyle.should == UIActivityIndicatorViewStyleWhite
    end

    it 'should default to the window center' do
      q = @vc.rmq.animations.start_spinner
      q.last.get.center.should == @vc.rmq.app.window.center
    end

    it 'should allow you to provide the center for the spinner' do
      q = @vc.rmq.animations.start_spinner(UIActivityIndicatorViewStyleWhiteLarge, { center: [10,10] })
      q.last.get.center.should == CGPointMake(10, 10)
    end

    it 'should allows you to provide the parent for the spinner' do
      parent = UIView.alloc.init
      q = @vc.rmq.animations.start_spinner(UIActivityIndicatorViewStyleWhiteLarge, { parent: parent })
      q.last.get.superview.should == parent
    end
  end

  it 'should stop spinner' do
    q = @vc.rmq.animations.stop_spinner
    q.first.get.is_a?(UIActivityIndicatorView).should == true
  end

  it 'should still invoke the callback if accessibility is on' do
    class RubyMotionQuery::Accessibility
      def self.voiceover_running?
        true
      end
    end

    @vc.rmq.animate(
    duration: 0.0,
    animations: -> (rmq) {
      # we shouldnt be running this proc as we have voiceover...
      # we put a failing exception here, which should not be processed
      1.should.equal("i ran animations and I shouldnt have!")
    },
    completion: -> (did_finish, rmq) {
      RubyMotionQuery::RMQ.is_blank?(rmq).should == false
    })
  end
end
