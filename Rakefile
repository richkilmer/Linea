# -*- coding: utf-8 -*-
$:.unshift("/Library/RubyMotion/lib")
require 'motion/project/template/ios'

begin
  require 'bundler'
  Bundler.require
rescue LoadError
end

$:.unshift(File.expand_path("../cocoamotion/lib"))
require 'cocoamotion'

$:.unshift(File.expand_path("../motion_cargosense_utils/lib"))
require 'cargosense_utils'


Motion::Project::App.setup do |app|
  # Use `rake config' to see complete project settings.

  app.version = "1.0"
  app.short_version = "1.0"
  
  app.name = 'Linea'
  app.detect_dependencies = true

  app.device_family = [:ipad, :iphone]

  app.development do
    app.identifier = "org.monotheos.Linea"
    puts 'Signing for development'
    app.codesign_certificate = "iPhone Developer: Richard Kilmer (GDL83WM2A9)"
    app.provisioning_profile = "/Users/rich/Library/MobileDevice/Provisioning Profiles/AnyAppDevelopment.mobileprovision"
    app.entitlements['get-task-allow'] = true
  end

  app.frameworks += ['CoreLocation']

end
