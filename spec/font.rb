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

  it 'should return a list of fonts for one family' do
    @rmq.font.for_family('Arial').grep(/Arial/).length.should > 0
  end

  it 'should return a system font given a size' do
    @rmq.font.system(11).is_a?(UIFont).should == true
  end

  it 'should return a system font with system default font size' do
    @rmq.font.system.pointSize.should == UIFont.systemFontSize
  end

  it 'should return font with name' do
    @rmq.font.with_name('American Typewriter', 11).is_a?(UIFont).should == true
  end

  it "should return fonts that have been named" do
    @rmq.font.add_named('awesome_font', 'American Typewriter', 12)
    @rmq.font.awesome_font.is_a?(UIFont).should.be.true
  end
end
