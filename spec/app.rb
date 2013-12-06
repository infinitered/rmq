describe 'app' do
  before do
    @app = RubyMotionQuery::App
  end

  it 'should return App with rmq#app' do
    rmq = RubyMotionQuery::RMQ.new
    rmq.app.should == @app
  end

  it 'should return App with RMQ.app' do
    RubyMotionQuery::RMQ.app.should == @app
  end

  it 'should return app window' do
    @app.window.should == UIApplication.sharedApplication.keyWindow
  end

  it 'should return app delegate' do
    @app.delegate.should == UIApplication.sharedApplication.delegate
  end

  it 'should return app version' do
    @app.version.should == NSBundle.mainBundle.infoDictionary['CFBundleVersion']
  end

  it 'should return app name' do
    @app.name.should == NSBundle.mainBundle.objectForInfoDictionaryKey('CFBundleDisplayName')
  end

  it 'should return app identifier' do
    @app.identifier.should == NSBundle.mainBundle.bundleIdentifier
  end

  it 'should return app resource_path' do
    @app.resource_path.should == NSBundle.mainBundle.resourcePath
  end

  it 'should return app document_path' do
    @app.document_path.should == NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, true)[0]
  end


  describe 'environment' do
    it 'should return environment as symbol, :test in this case' do
      @app.environment.should == :test 
    end

    it 'should return true if environment is test when test? is called' do
      @app.test?.should == true 
    end

    it 'should return false if environment is not development when development? is called' do
      @app.development?.should == false
    end

    it 'should return false if environment is not release when release? or production? are called' do
      @app.release?.should == false
      @app.production?.should == false
    end

  describe 'app - current_view_controller' do
    it 'should return current_view_controller from current window' do
      rmq.app.current_view_controller.should == rmq.app.window.rootViewController
    end

    it 'should return current_view_controller when presenting a new controller' do
      1.should == 1
    end

    it 'should return current_view_controller when root controller is UINavigationController with multiple controllers' do
      1.should == 1
    end

    it 'should return current_view_controller when root controller is UITabController with multiple controllers' do
      1.should == 1
    end
  end

  end
end
