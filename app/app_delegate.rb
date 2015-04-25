class AppDelegate
  include CocoaMotion::AppBehaviors
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    @window = build :window, :main, root_controller: build(:navigation_controller, :main, :root_controller => LineaController)
    true
  end
end
