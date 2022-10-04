Pod::Spec.new do |spec|
  spec.name         = "AKUserDefaultsManager"
  spec.version      = "1.0.0"
  spec.summary      = "Generic UserDefaults manager for setting, getting, checking and deleting key value pairs"
  spec.description  = "Custom UserDefaults Wrapper Module"

  spec.homepage     = "http://domain.ext/AKUserDefaultsManager"
  spec.author       = { "Ashwin K" => "ashwin.k@navi.com" }
  spec.ios.deployment_target = "15.0"
  spec.source       = { :git => "http://www.github.com/AKUserDefaultsManager.git", :tag => "#{spec.version}" }
  spec.source_files  = "AKUserDefaultsManager", "AKUserDefaultsManager/**/*.{swift,xib}"
  spec.exclude_files = "Classes/Exclude"
end
