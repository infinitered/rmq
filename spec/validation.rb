describe 'validation' do
  before do
    @rmq = RubyMotionQuery::RMQ
  end

  it 'should return validation from RMQ or an instance of rmq' do
    @rmq.validation.should == RubyMotionQuery::Validation

    rmq = RubyMotionQuery::RMQ.new
    rmq.validation.should == RubyMotionQuery::Validation
  end

  describe 'plumbing methods' do
    it 'should match regex to boolean' do
      @rmq.validation.regex_match?('test', /test/).should == true
      @rmq.validation.regex_match?('test', /taco/).should == false
    end
  end

  describe 'valid?' do
    it 'can validate email' do
      @rmq.validation.valid?('test@test', :email).should == false
      @rmq.validation.valid?('test@test.com', :email).should == true
      @rmq.validation.valid?('test', :email).should == false
    end

    it 'can validate url' do
      @rmq.validation.valid?('https://www.infinitered.com', :url).should == true
      @rmq.validation.valid?('test', :url).should == false
    end

    it 'can validate dateiso' do
      @rmq.validation.valid?('2014-03-02', :dateiso).should == true
      @rmq.validation.valid?('test', :dateiso).should == false
    end

    it 'can validate number' do
      @rmq.validation.valid?('53.9', :number).should == true
      @rmq.validation.valid?(98.6, :number).should == true
      @rmq.validation.valid?('test', :number).should == false
    end

    it 'can validate digits' do
      @rmq.validation.valid?('45', :digits).should == true
      @rmq.validation.valid?(69, :digits).should == true
      @rmq.validation.valid?('test', :digits).should == false
      @rmq.validation.valid?(6.9, :digits).should == false
    end

    it 'can validate ipv4' do
      @rmq.validation.valid?('192.168.1.1', :ipv4).should == true
      @rmq.validation.valid?('192.168.1.', :ipv4).should == false
    end

    it 'can validate time' do
      @rmq.validation.valid?('10:23', :time).should == true
      @rmq.validation.valid?('test', :time).should == false
    end

    it 'can validate uszip' do
      @rmq.validation.valid?('70003', :uszip).should == true
      @rmq.validation.valid?('70003-8844', :uszip).should == true
      @rmq.validation.valid?('K1A 0B1', :uszip).should == false
    end

    it 'can validate usphone' do
      @rmq.validation.valid?('504 555 8989', :usphone).should == true
      @rmq.validation.valid?('555 8989', :usphone).should == true
      @rmq.validation.valid?('504.555.8989', :usphone).should == true
      @rmq.validation.valid?('504-555-8989', :usphone).should == true
      @rmq.validation.valid?('5045558989', :usphone).should == true
      @rmq.validation.valid?('504 555 8989 x1227', :usphone).should == false
      @rmq.validation.valid?('test', :usphone).should == false
    end

    it 'can validate at least 1 uppercase US character' do
      @rmq.validation.valid?('test', :has_upper).should == false
      @rmq.validation.valid?('Test', :has_upper).should == true
    end

    it 'can validate at least 1 uppercase US character' do
      @rmq.validation.valid?('TEST', :has_lower).should == false
      @rmq.validation.valid?('Test', :has_lower).should == true
    end

    it 'can validate a strong password of at least 8 chars, 1 upper, 1 lower, and a number' do
      @rmq.validation.valid?('PAss1', :strong_password).should == false # length
      @rmq.validation.valid?('pass1word', :strong_password).should == false # no upper
      @rmq.validation.valid?('PASS1WORD', :strong_password).should == false # no lower
      @rmq.validation.valid?('PassworD', :strong_password).should == false # no number
      @rmq.validation.valid?('Pass1word', :strong_password).should == true # just right
    end

    it 'can validate presence' do
      @rmq.validation.valid?('       ', :presence).should == false
      @rmq.validation.valid?('   x   ', :presence).should == true
    end

    it 'can validate the length' do
      @rmq.validation.valid?('test', :length, exact_length: 5).should == false
      @rmq.validation.valid?('test', :length, exact_length: 4).should == true
      @rmq.validation.valid?('test', :length, min_length: 5).should == false
      @rmq.validation.valid?('test', :length, min_length: 4).should == true
      @rmq.validation.valid?('test', :length, max_length: 3).should == false
      @rmq.validation.valid?('test', :length, max_length: 4).should == true
      # create a range both ways
      @rmq.validation.valid?('test', :length, min_length: 2, max_length: 7).should == true
      @rmq.validation.valid?('test', :length, min_length: 8, max_length: 16).should == false
      @rmq.validation.valid?('test', :length, exact_length: 2..7).should == true
      @rmq.validation.valid?('test', :length, exact_length: 8..16).should == false
      # Next 2 lines testing ignore pre/post whitespace in length
      @rmq.validation.valid?(' test ', :length, min_length: 5).should == true
      @rmq.validation.valid?(' test ', :length, min_length: 5, strip: true).should == false
    end

    it 'can validate custom regex' do
      @rmq.validation.valid?('test', :custom, regex: /^test$/).should == true
      @rmq.validation.valid?('test', :custom, regex: /^beach$/).should == false
      # Regex not supplied
      @rmq.validation.valid?('test', :custom).should == false
    end

    it 'raises an RuntimeError for missing validation methods' do
      should.raise(RuntimeError) do
        @rmq.validation.valid?('test', :madeupthing)
      end
      should.not.raise(RuntimeError) do
        @rmq.validation.valid?('test', :email)
        @rmq.validation.valid?('test@test.com', :email)
      end
    end

    it 'ignores validation checks if debugging is set to true' do
      # Utility level
      @rmq.validation.valid?('taco loco', :digits).should == false
      RubyMotionQuery::RMQ.debugging = true
      @rmq.validation.valid?('taco loco', :digits).should == true
      RubyMotionQuery::RMQ.debugging = false
      @rmq.validation.valid?('taco loco', :digits).should == false

      # Validation Selection level - (Added test because inital release of 0.7 didn't work)
      vc = UIViewController.alloc.init
      vc.rmq.append(UITextField).validates(:digits).data('taco loco').tag(:one)
      RubyMotionQuery::RMQ.debugging = true
      vc.rmq(:one).valid?.should == true
      RubyMotionQuery::RMQ.debugging = false
      vc.rmq(:one).valid?.should == false
    end

    it 'validates to true if allow_blank options is set' do
      @rmq.validation.valid?('', :email).should == false
      @rmq.validation.valid?('', :email, allow_blank: true).should == true
    end

    it 'accepts a whitelist of validation overrides' do
      # Utility Level
      @rmq.validation.valid?('http://localhost:3000', :url).should == false
      @rmq.validation.valid?('http://localhost:3000', :url, white_list: ['http://localhost:8080', 'http://localhost:3000']).should == true

      # Validation Selection level
      vc = UIViewController.new
      vc.rmq.append(UITextField).validates(:number).data('N/A').tag(:one)
      vc.rmq(:one).valid?.should == false
      vc.rmq.append(UITextField).validates(:number, white_list: ['N/A']).data('N/A').tag(:two)
      vc.rmq(:two).valid?.should == true
    end

    it 'checks validations based on selections' do
      vc = UIViewController.alloc.init

      vc.rmq.append(UITextField).validates(:digits).data('taco loco').tag(:one)
      vc.rmq.append(UITextField).validates(:digits).data('123455').tag(:two)
      vc.rmq.append(UITextField).validates(:digits).data('1234').tag(:three)
      # selections with options
      vc.rmq.append(UITextField).validates(:length, min_length: 2, max_length: 10).data('1234').tag(:four)
      vc.rmq.append(UITextField).validates(:length, exact_length: 5).data('1234').tag(:five)

      vc.rmq.all.valid?.should == false
      vc.rmq(:one).valid?.should == false
      vc.rmq(:one, :two).valid?.should == false
      vc.rmq(:three, :two).valid?.should == true
      vc.rmq(:four).valid?.should == true
      vc.rmq(:five).valid?.should == false

    end

    it 'maintains what selected items are invalid' do
      vc = UIViewController.alloc.init

      vc.rmq.append(UITextField).validates(:length, max_length: 1).validates(:digits).data('taco loco').tag(:one)
      vc.rmq.append(UITextField).validates(:digits).data('123455').tag(:two)

      #everything is valid by default
      vc.rmq.all.invalid.should == []
      vc.rmq.all.valid? # this flags the items
      vc.rmq.all.invalid.should == [vc.rmq(:one).get]
    end

    it 'maintains what selected items are valid' do
      vc = UIViewController.alloc.init

      vc.rmq.append(UITextField).validates(:digits).data('taco loco').tag(:one)
      vc.rmq.append(UITextField).validates(:length, min_length: 1).validates(:digits).data('123455').tag(:two)

      #everything is valid by default
      vc.rmq.all.valid.size.should == 2
      vc.rmq.all.valid? # this flags the items
      vc.rmq.all.valid.should == [vc.rmq(:two).get]
    end

    it 'clears all validations on demand' do
      vc = UIViewController.new

      vc.rmq.all.valid?.should == true
      vc.rmq.append(UITextField).validates(:digits).data('tacorama').tag(:one)
      vc.rmq.append(UITextField).validates(:digits).data('not digits').tag(:two)
      vc.rmq.all.valid?.should == false
      vc.rmq.all.clear_validations!
      vc.rmq.all.valid?.should == true

    end

    it 'raises :invalid and :valid events that can be acted on' do
      valid_text = "validation for field failed"
      invalid_text = "validation for field success"

      vc = UIViewController.alloc.init
      vc.rmq.append(UILabel).tag(:validation_message)

      vc.rmq.append(UITextField).validates(:digits).tag(:one).
        on(:valid) do |valid|
          vc.rmq(:validation_message).get.text = valid_text
        end.
        on(:invalid) do |valid|
          vc.rmq(:validation_message).get.text = invalid_text
        end

      vc.rmq(:one).get.text = "abc"
      vc.rmq.all.valid?

      vc.rmq(:validation_message).get.text.should == invalid_text

      vc.rmq(:one).get.text = "123"
      vc.rmq.all.valid?
      vc.rmq(:validation_message).get.text.should == valid_text
    end

    it 'can return default error messages' do
      vc = UIViewController.new

      vc.rmq.append(UITextField).validates(:digits).data('123').tag(:one)
      vc.rmq.append(UITextField).validates(:email).validates(:length, min_length: 7).data('test@test.com').tag(:two)
      # all as expected?
      vc.rmq.all.valid?.should == true
      vc.rmq.all.validation_errors.should == []

      #invalidate one of them, see what pops out
      vc.rmq(:one).data('burrito')
      vc.rmq.all.valid?.should == false
      vc.rmq.all.validation_errors.length.should == 1

      #invalidate the other
      vc.rmq(:two).data('nachos')
      vc.rmq.all.valid?.should == false
      # should get 2 invalidations
      vc.rmq.all.validation_errors.length.should == 3

      #can get specific view messages
      vc.rmq(:two).validation_errors.length.should == 2

    end

    it 'can return custom error messages' do
      vc = UIViewController.new
      vc.rmq.stylesheet = StyleSheetForStylesheetTests

      vc.rmq.append(UITextField, :digits_field).validates(:digits).data('123').tag(:one)
      vc.rmq.all.valid?.should == true

      vc.rmq(:one).data('enchilada').valid?.should == false
      vc.rmq.all.validation_errors.length.should == 1
      vc.rmq.all.validation_errors.first.should == "custom error messsage"
    end

  end

  describe 'adding a custom validator' do
    before do
      @rmq.validation.add_validator(:start_with) do |value, opts|
        value.start_with?(opts[:prefix])
      end
    end

    it "should raise a ArgumentError when no block is given" do
      should.raise(ArgumentError) do
        @rmq.validation.add_validator(:no_block)
      end
    end

    it "should not raise a RuntimeError for a missing validation method" do
      should.not.raise(RuntimeError) do
        validation = @rmq.validation.new(:start_with)
      end
    end

    it "should validate at utility and selection level" do
      # Utility Level
      @rmq.validation.valid?('test', :start_with, {prefix: 'te'}).should == true
      @rmq.validation.valid?('test', :start_with, {prefix: 'est'}).should == false

      # Validation Selection level
      vc = UIViewController.new
      vc.rmq.append(UITextField).validates(:start_with, prefix: 'x').data('test').tag(:one)
      vc.rmq(:one).valid?.should == false
      vc.rmq.append(UITextField).validates(:start_with, prefix: 't').data('test').tag(:two)
      vc.rmq(:two).valid?.should == true
    end
  end


end
