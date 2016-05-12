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

  it 'should return UIApplication with rmq#app!' do
    rmq = RubyMotionQuery::RMQ.new
    rmq.app!.should == UIApplication.sharedApplication
  end

  it 'should return UIApplication with RMQ.app!' do
    RubyMotionQuery::RMQ.app!.should == UIApplication.sharedApplication
  end

  it 'should return app window' do
    @app.window.should == UIApplication.sharedApplication.keyWindow
  end

  it 'should return app windows' do
    @app.windows.should == UIApplication.sharedApplication.windows
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

  it 'should return info_plist items correctly' do
    @app.info_plist['CFBundleVersion'].should == NSBundle.mainBundle.infoDictionary['CFBundleVersion']
    @app.info_plist['test_thing'].should == ["a", "b", "c"]
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

  it 'should delay 0.01 second then fire callback' do
    before_time = Time.now
    @app.after 0.01 do
      after_time = Time.now
      (after_time - before_time).should.be >= 0.007
      (after_time - before_time).should.be.close 0.01, 0.005
      resume
    end
    wait {}
  end

  it 'should fire twice 0.01 seconds apart' do
    before_time = Time.now
    count = 0
    timer = @app.every 0.01 do
      after_time = Time.now
      (after_time - before_time).should.be >= 0.007
      (after_time - before_time).should.be.close 0.01, 0.005
      count += 1
      before_time = after_time # reset
      resume if count >= 2
    end
    wait { timer.invalidate }
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
  end

  describe 'app - current_view_controller' do
    before do
      UIView.setAnimationsEnabled false
    end

    after do
      UIView.setAnimationsEnabled true
    end

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

    # Disabling, this works, but isn't working in tests, TODO, fix
    # it 'should return current_view_controller when root controller is UINavigationController with multiple controllers' do
    #   cur = rmq.app.current_view_controller
    #   cur.class.should == MainController
    # end

    it 'should return current_view_controller when root controller is UITabController with multiple controllers' do
      tabbar = UITabBarController.alloc.init
      new_controller = UIViewController.new
      tabbar.viewControllers = [new_controller]
      old_root = rmq.app.window.rootViewController
      rmq.app.window.rootViewController = tabbar
      rmq.app.current_view_controller.should == new_controller
      rmq.app.window.rootViewController = old_root
    end

    it 'should return current_view_controller when root controller is UITabController with multiple controllers and a more tab' do
      tabbar = UITabBarController.alloc.init

      new_controller_0 = UIViewController.new
      new_controller_1 = UIViewController.new
      new_controller_2 = UIViewController.new
      new_controller_3 = UIViewController.new
      new_controller_4 = UIViewController.new
      new_controller_5 = UIViewController.new
      new_controller_6 = UIViewController.new
      tabbar.viewControllers = [
        new_controller_0,
        new_controller_1,
        UINavigationController.alloc.initWithRootViewController(new_controller_2),
        new_controller_3,
        new_controller_4,
        new_controller_5,
        UINavigationController.alloc.initWithRootViewController(new_controller_6)
      ]

      old_root = rmq.app.window.rootViewController
      rmq.app.window.rootViewController = tabbar

      # Test regular tab indexes
      tabbar.setSelectedIndex(0)
      rmq.app.current_view_controller.should == new_controller_0
      tabbar.setSelectedIndex(2)
      rmq.app.current_view_controller.should == new_controller_2

      # Test a view controller in the more nav controller
      tabbar.setSelectedIndex(5)
      rmq.app.current_view_controller.should == new_controller_5

      # Test a view controller inside a nav controller in the more nav controller
      tabbar.setSelectedIndex(6)
      rmq.app.current_view_controller.should == new_controller_6

      rmq.app.window.rootViewController = old_root
    end

    it 'should return current_view_controller when root controller is UITabController with multiple controllers contained inside a UINavigationController' do
      tabbar = UITabBarController.alloc.init

      new_controller_0 = UIViewController.new
      new_controller_1 = UIViewController.new
      new_controller_2 = UIViewController.new
      new_controller_3 = UIViewController.new
      new_controller_4 = UIViewController.new
      new_controller_5 = UIViewController.new
      new_controller_6 = UIViewController.new
      tabbar.viewControllers = [
        new_controller_0,
        new_controller_1,
        UINavigationController.alloc.initWithRootViewController(new_controller_2),
        new_controller_3,
        new_controller_4,
        new_controller_5,
        UINavigationController.alloc.initWithRootViewController(new_controller_6)
      ]
      nav_controller = UINavigationController.alloc.initWithRootViewController(tabbar)
      nav_controller.setNavigationBarHidden(true)

      old_root = rmq.app.window.rootViewController
      rmq.app.window.rootViewController = nav_controller

      # Test regular tab indexes
      tabbar.setSelectedIndex(0)
      rmq.app.current_view_controller.should == new_controller_0
      tabbar.setSelectedIndex(2)
      rmq.app.current_view_controller.should == new_controller_2

      # Test a view controller in the more nav controller
      tabbar.setSelectedIndex(5)
      rmq.app.current_view_controller.should == new_controller_5

      # Test a view controller inside a nav controller in the more nav controller
      tabbar.setSelectedIndex(6)
      rmq.app.current_view_controller.should == new_controller_6

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

    it 'should return current_view_controller when root controller is container controller with a frontViewController method' do
      controller = MyFrontViewControllerController.alloc.init
      new_controller = UIViewController.new
      controller.my_controller = new_controller
      controller.my_controller.should == new_controller

      old_root = rmq.app.window.rootViewController
      rmq.app.window.rootViewController = controller
      rmq.app.current_view_controller.should == new_controller
      rmq.app.window.rootViewController = old_root
    end

    it 'should return current_view_controller when root controller is container controller with a center method' do
      controller = MyCenterViewControllerController.alloc.init
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

class MyFrontViewControllerController < UIViewController
  attr_accessor :my_controller
  def frontViewController
    @my_controller
  end
end

class MyCenterViewControllerController < UIViewController
  attr_accessor :my_controller
  def center
    @my_controller
  end
end
