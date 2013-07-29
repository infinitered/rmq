class AppDelegate
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = UIWindow.alloc.initWithFrame(UIScreen.mainScreen.bounds)

    main_controller = MainController.alloc.initWithNibName(nil, bundle: nil)
    @window.rootViewController = main_controller

    @window.makeKeyAndVisible
    true
  end
end
