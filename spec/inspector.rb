describe 'inspector' do

  before do
    UIView.setAnimationsEnabled false
  end

  after do
    UIView.setAnimationsEnabled true
  end

  it 'should open inspector view' do
    rmq.all.inspector
    ivq = rmq(rmq.window).find(RubyMotionQuery::InspectorView)
    ivq.length.should == 1
    ivq.remove
  end
end
