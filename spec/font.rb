describe 'font' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'should return font from RMQ or an instance of rmq' do
    @rmq.font.should == RubyMotionQuery::Font

    rmq = RubyMotionQuery::RMQ.new
    rmq.font.should == RubyMotionQuery::Font
  end

  it 'should return a list of font families' do
    @rmq.font.family_list.grep(/Helvetica/).length.should > 0
  end

  it 'should return a list of fonts for one family ' do
    @rmq.font.for_family('Arial').grep(/Arial/).length.should > 0
  end

  it 'should return a system fone given a size' do
    @rmq.font.system(11).is_a?(UIFont).should == true
  end

  #TODO test font_with_name
  
  #TODO test named fonts
end
