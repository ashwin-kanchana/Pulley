Pod::Spec.new do |spec|
  spec.name         = "AKNetworkManager"
  spec.version      = "1.0.0"
  spec.summary      = "Generic network manager for loading data and images"
  spec.description  = "Network Module"

  spec.homepage     = "http://domain.ext/AKNetworkManager"
  spec.author       = { "Ashwin K" => "ashwin.k@navi.com" }
  spec.ios.deployment_target = "15.0"
  spec.source       = { :git => "http://www.github.com/AKNetworkManager.git", :tag => "#{spec.version}" }
  spec.source_files  = "AKNetworkManager", "AKNetworkManager/**/*.{swift,xib}"
  spec.exclude_files = "Classes/Exclude"
end
