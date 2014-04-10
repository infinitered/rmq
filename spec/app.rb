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
    it 'should return controller that is passed in to current_view_controller if it is justa UIViewController' do
      new_controller = UIViewController.new
      rmq.app.current_view_controller(new_controller).should == new_controller
    end

    it 'should return current_view_controller from current window' do
      rmq.app.current_view_controller.should == rmq.app.window.rootViewController.visibleViewController
    end

    it 'should return current_view_controller when presenting a new controller' do
      controller = UIViewController.alloc.init
      rmq.app.window.rootViewController.presentViewController(controller, animated: false, completion: nil)
      rmq.app.current_view_controller.should == controller
      controller.dismissViewControllerAnimated(false, completion: nil)
    end

    it 'should return current_view_controller when root controller is UINavigationController with multiple controllers' do
      rmq.app.current_view_controller.class.should == MainController
    end

    it 'should return current_view_controller when root controller is UITabController with multiple controllers' do
      tabbar = UITabBarController.alloc.init
      new_controller = UIViewController.new
      tabbar.viewControllers = [new_controller]
      old_root = rmq.app.window.rootViewController
      rmq.app.window.rootViewController = tabbar
      rmq.app.current_view_controller.should == new_controller
      rmq.app.window.rootViewController = old_root
    end

    it 'should return current_view_controller when root controller is container controller with a topViewController method' do
      controller = MyTopViewController.alloc.init
      new_controller = UIViewController.new
      controller.my_controller = new_controller
      controller.my_controller.should == new_controller

      old_root = rmq.app.window.rootViewController
      rmq.app.window.rootViewController = controller
      rmq.app.current_view_controller.should == new_controller
      rmq.app.window.rootViewController = old_root
    end


    it 'should return current_view_controller when root controller is container controller with a visibleViewController method' do
      controller = MyVisibleViewController.alloc.init
      new_controller = UIViewController.new
      controller.my_controller = new_controller
      controller.my_controller.should == new_controller

      old_root = rmq.app.window.rootViewController
      rmq.app.window.rootViewController = controller
      rmq.app.current_view_controller.should == new_controller
      rmq.app.window.rootViewController = old_root
    end

    it 'should return current_view_controller when root controller is container controller with more than one child controllers' do
      # TODO
      1.should == 1
    end
  end

  end
end


class MyTopViewController < UIViewController
  attr_accessor :my_controller
  def topViewController
    @my_controller
  end
end

class MyVisibleViewController < UIViewController
  attr_accessor :my_controller
  def visibleViewController
    @my_controller
  end
end
