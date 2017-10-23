Pod::Spec.new do |s|
  s.name         = "VYPlayIndicator"
  s.version      = "1.5.1"
  s.summary      = "VYPlayIndicator is a CALayer Class to indicate a song is playing."
  s.homepage     = "https://github.com/docterd/VYPlayIndicator"
  s.license      = { :type => "MIT" }
  s.author       = { "Dennis Oberhoff" => "dennisoberhoff@gmail.com" }
  s.source       = { :git => "https://github.com/docterd/VYPlayIndicator.git", :tag => "1.5.1"}
  s.source_files  = "Classes", "Classes/*.{h,m,c}"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.8"
end
