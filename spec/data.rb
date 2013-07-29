describe 'rmq_data' do
  it 'should exist on a view and controller' do
    view_controller = UIViewController.alloc.init
    root_view = view_controller.view

    root_view.rmq_data.is_a?(RubyMotionQuery::ViewData).should == true
    view_controller.rmq_data.is_a?(RubyMotionQuery::ControllerData).should == true
  end

  it 'should store various data' do
    # Just make sure no one messes with stuff
    UIViewController.alloc.init.tap do |vc|
      vc.rmq_data.stylesheet = :foo
      vc.rmq_data.stylesheet.should == :foo

      q = vc.rmq
      vc.rmq_data.rmq = q
      vc.rmq_data.rmq.should == q

      vc.view.rmq_data.tap do |q_data|
        q_data.style_name = :style_name
        q_data.style_name.should == :style_name

        q_data.events = :events
        q_data.events.should == :events
      end
    end
  end

  # Tags are tested in spec/tags.rb
end
