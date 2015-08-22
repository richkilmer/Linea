class AppDelegate
  include CocoaMotion::AppBehaviors
  
  def application(application, didFinishLaunchingWithOptions:launchOptions)
    initialize_database
    
    @window = build :window, :main, root_controller: build(:navigation_controller, :main, :root_controller => LineaController)
    true
  end

  def initialize_database
    NanoStore.shared_store = NanoStore.store(:file, App.documents_path + "/linea.db")
  end

end
