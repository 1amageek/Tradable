
Pod::Spec.new do |s|

  s.name         = "Tradable"
  s.version      = "0.0.4"
  s.summary      = "Firestore trade framework"
  s.description  = <<-DESC
Tradable is a library for doing business.
                   DESC
  s.homepage     = "https://github.com/1amageek/Tradable"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author             = { "1amageek" => "tmy0x3@icloud.com" }
  s.social_media_url   = "http://twitter.com/1amageek"
  s.platform     = :ios, "10.0"
  # s.ios.deployment_target = "11.0"
  # s.osx.deployment_target = "10.7"
  # s.watchos.deployment_target = "2.0"
  # s.tvos.deployment_target = "9.0"
  s.source       = { :git => "https://github.com/1amageek/Tradable.git", :tag => "#{s.version}" }
  s.source_files  = "Tradable/**/*.swift"
  s.requires_arc = true
  s.static_framework = true
  s.dependency "Pring"
  s.dependency "Firebase/Core"
  s.dependency "Firebase/Firestore"
  s.dependency "Firebase/Auth"
end
