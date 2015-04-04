describe "MainController" do
  tests MainController

  DELAY = 0.2
  # This line is needed if this test is ever run independently
  UIView.setAnimationsEnabled false

  it 'starts with no keyboard shown' do 
    controller.keyboard_visible.nil?.should == true
    controller.rmq.app.hide_keyboard.should == false
  end

  it 'can hide the keyboard with rmq.app.hide_keyboard' do
    # force keyboard to show
    controller.rmq(:only_digits).get.becomeFirstResponder
    wait DELAY do
      controller.keyboard_visible.should == true
    end

    # hide keyboard (have to wait for first delay to finish)
    wait DELAY * 2 do 
      controller.rmq.app.hide_keyboard.should == true
      wait DELAY do 
        controller.keyboard_visible.should == false
      end
    end
  end



  it 'has aliases for rmq.app.hide_keyboard' do
    rmq.app.respond_to?(:resign_responders).should == true
    rmq.app.respond_to?(:end_editing).should == true
    controller.rmq.app.resign_responders.should == false
    controller.rmq.app.end_editing.should == false
  end
end