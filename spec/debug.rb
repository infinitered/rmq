describe 'debug' do
  should 'assert value is true' do 
    a = true
    RubyMotionQuery::Debug.assert(1==1) do
      a = false
      {}
    end
    a.should == true
  end
end
