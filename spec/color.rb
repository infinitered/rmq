describe 'color' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'should return color from RMQ or an instance of rmq' do
    @rmq.color.should == RubyMotionQuery::Color

    rmq = RubyMotionQuery::RMQ.new
    rmq.color.should == RubyMotionQuery::Color
  end

  describe 'Standard colors' do
    it 'should alias standard UIColors' do
      @rmq.color.clear.should == UIColor.clearColor
      @rmq.color.white.should == UIColor.whiteColor
      @rmq.color.light_gray.should == UIColor.lightGrayColor
      @rmq.color.gray.should == UIColor.grayColor
      @rmq.color.dark_gray.should == UIColor.darkGrayColor
      @rmq.color.black.should == UIColor.blackColor
      @rmq.color.red.should == UIColor.redColor
      @rmq.color.green.should == UIColor.greenColor
      @rmq.color.blue.should == UIColor.blueColor
      @rmq.color.yellow.should == UIColor.yellowColor
      @rmq.color.orange.should == UIColor.orangeColor
      @rmq.color.purple.should == UIColor.purpleColor
      @rmq.color.brown.should == UIColor.brownColor
      @rmq.color.cyan.should == UIColor.cyanColor
      @rmq.color.magenta.should == UIColor.magentaColor
      @rmq.color.table_view.should == UIColor.groupTableViewBackgroundColor
      @rmq.color.scroll_view.should == UIColor.scrollViewTexturedBackgroundColor
      @rmq.color.flipside.should == UIColor.viewFlipsideBackgroundColor
      @rmq.color.under_page.should == UIColor.underPageBackgroundColor
      @rmq.color.dark_text.should == UIColor.darkTextColor
      @rmq.color.light_text.should == UIColor.lightTextColor
    end
  end

  describe 'add_named' do
    it 'should define a method and return the correct color when a color is provided' do
      @rmq.color.respond_to?(:some_new_color).should == false
      @rmq.color.add_named('some_new_color', UIColor.redColor)
      @rmq.color.some_new_color.should == UIColor.redColor
    end
  end

  describe 'from_hex' do
    it 'translates the color properly' do
      @rmq.color.from_hex('ffffff').should == UIColor.colorWithRed(255, green: 255, blue: 255, alpha: 1)
      @rmq.color.from_hex('000000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
    end

    it 'ignores a leading "#"' do
      @rmq.color.from_hex('#ffffff').should == UIColor.colorWithRed(255, green: 255, blue: 255, alpha: 1)
      @rmq.color.from_hex('#000000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
    end

    it 'raises an ArgumentError for lengths not 3 or 6' do
      should.raise(ArgumentError) do
        @rmq.color.from_hex('ffffffffffffffff')
      end
      should.raise(ArgumentError) do
        @rmq.color.from_hex('f')
      end
      should.not.raise(ArgumentError) do
        @rmq.color.from_hex('fff')
        @rmq.color.from_hex('ffffff')
      end
    end
  end

  describe 'from_hsva' do
    it 'returns the correct color' do
      @rmq.color.from_hsva(4,3,2,1).should == UIColor.alloc.initWithHue(4, saturation: 3, brightness: 2, alpha: 1)
    end
  end

  describe 'from_rgba' do
    it 'returns the correct color' do
      @rmq.color.from_rgba(0,0,0,1).should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
      @rmq.color.from_rgba(10,10,10,1).should == UIColor.colorWithRed(10/255.0, green: 10/255.0, blue: 10/255.0, alpha: 1)
    end
  end

  describe 'random' do
    it 'should return a color' do
      @rmq.color.random.is_a?(UIColor).should == true
    end
  end
end
