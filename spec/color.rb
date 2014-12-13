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
      @rmq.color.from_hex('ffffff00').should == UIColor.colorWithRed(255, green: 255, blue: 255, alpha: 0)
      @rmq.color.from_hex('ffffff').should == UIColor.colorWithRed(255, green: 255, blue: 255, alpha: 1)
      @rmq.color.from_hex('000000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
      @rmq.color.from_hex('0000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 0)
    end

    it 'ignores a leading "#"' do
      @rmq.color.from_hex('#ffffff00').should == UIColor.colorWithRed(255, green: 255, blue: 255, alpha: 0)
      @rmq.color.from_hex('#ffffff').should == UIColor.colorWithRed(255, green: 255, blue: 255, alpha: 1)
      @rmq.color.from_hex('#000000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
      @rmq.color.from_hex('#0000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 0)
    end

    it 'raises an ArgumentError for lengths not 3, 4, 6 or 8' do
      should.raise(ArgumentError) do
        @rmq.color.from_hex('ffffffffffffffff')
      end
      should.raise(ArgumentError) do
        @rmq.color.from_hex('fffffff')
      end
      should.raise(ArgumentError) do
        @rmq.color.from_hex('fffff')
      end
      should.raise(ArgumentError) do
        @rmq.color.from_hex('f')
      end
      should.not.raise(ArgumentError) do
        @rmq.color.from_hex('fff')
        @rmq.color.from_hex('ffff')
        @rmq.color.from_hex('ffffff')
        @rmq.color.from_hex('ffffffff')
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

  describe 'when passing parameters to color' do

    it 'should work on a RMQ class or instance' do
      @rmq.color('000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)

      rmq = RubyMotionQuery::RMQ.new
      rmq.color('000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
    end

    it 'should return proper colors for values that have 3, 4, 6, and 8 character length strings representing a hex color' do
      @rmq.color('000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
      @rmq.color('0000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 0)
      @rmq.color('ffffff').should == UIColor.colorWithRed(255, green: 255, blue: 255, alpha: 1)
      @rmq.color('ffffff00').should == UIColor.colorWithRed(255, green: 255, blue: 255, alpha: 0)
    end

    it 'should ignore leading "#"`s when hex colors are provided' do
      @rmq.color('#000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
      @rmq.color('#0000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 0)
      @rmq.color('#ffffff').should == UIColor.colorWithRed(255, green: 255, blue: 255, alpha: 1)
      @rmq.color('#ffffff00').should == UIColor.colorWithRed(255, green: 255, blue: 255, alpha: 0)
    end

    it 'should return the correct color when a "x" key value is passed representing a hex color' do
      @rmq.color(x: '#000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
      @rmq.color(x: '000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
    end

    it 'should return the correct color when a "hex" key value is passed representing a hex color' do
      @rmq.color(hex: '#000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
      @rmq.color(hex: '000').should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
    end

    it 'should return the correct color when a hex color and alpha value is provided' do
      @rmq.color(hex: '#000', alpha: 0.5).should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 0.5)
      @rmq.color(hex: '#000', a: 0.5).should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 0.5)
      @rmq.color(hex: '000', a: 0.5).should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 0.5)

      @rmq.color(x: '000', a: 0.5).should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 0.5)
      @rmq.color(x: '000', alpha: 0.5).should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 0.5)
    end

    it 'should return the correct color when `clean` values such as `#808080` are provided' do
      @rmq.color('#808080').should == UIColor.colorWithRed(0.5, green: 0.5, blue: 0.5, alpha: 1)
      @rmq.color('808080').should == UIColor.colorWithRed(0.5, green: 0.5, blue: 0.5, alpha: 1)
    end

    it 'raises an ArgumentError for lengths not 3, 4, 6 or 8' do
      should.raise(ArgumentError) do
        @rmq.color('ffffffffffffffff')
      end
      should.raise(ArgumentError) do
        @rmq.color('fffffff')
      end
   should.raise(ArgumentError) do
        @rmq.color('fffff')
      end
      should.raise(ArgumentError) do
        @rmq.color('f')
      end
      should.not.raise(ArgumentError) do
        @rmq.color('fff')
        @rmq.color('ffff')
        @rmq.color('ffffff')
        @rmq.color('ffffffff')
      end
    end

    it 'should allow rgba params' do
      @rmq.color(0,0,0,1).should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
      @rmq.color(10,10,10,1).should == UIColor.colorWithRed(10/255.0, green: 10/255.0, blue: 10/255.0, alpha: 1)
      @rmq.color(16,16,16,1).should == UIColor.colorWithRed(16/256.0, green: 16/256.0, blue: 16/256.0, alpha: 1)
    end

    it 'should allow rgba params in a hash' do
      @rmq.color(r: 0, g: 0, b: 0, a: 1).should == UIColor.colorWithRed(0, green: 0, blue: 0, alpha: 1)
      @rmq.color(red: 10, green: 10, blue: 10, alpha: 1).should == UIColor.colorWithRed(10/255.0, green: 10/255.0, blue: 10/255.0, alpha: 1)
    end

    it 'raises an ArgumentError when only a portion of the rgba params is provided' do
      should.raise(ArgumentError) do
        @rmq.color(r:0)
      end
    end

    it 'defaults the alpha value when rgb(a) values are provided' do
      should.not.raise(ArgumentError) do
        @rmq.color(r: 0, g: 0, b: 0)
      end
    end

    it 'should allow hsva params in a hash' do
      @rmq.color(h: 4, s: 3, b: 2, a: 1).should == UIColor.alloc.initWithHue(4, saturation: 3, brightness: 2, alpha: 1)
      @rmq.color(hue: 4, saturation: 3, brightness: 2, alpha: 1).should == UIColor.alloc.initWithHue(4, saturation: 3, brightness: 2, alpha: 1)
    end

    it 'raises an ArgumentError when only a portion of the hsva params is provided' do
      should.raise(ArgumentError) do
        @rmq.color(h: 4)
      end
    end

    it 'defaults the alpha value when hsv(a) values are provided' do
      should.not.raise(ArgumentError) do
        @rmq.color(h: 4, s: 3, b: 2)
      end
    end
  end
end
