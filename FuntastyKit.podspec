Pod::Spec.new do |s|
  s.name = "FuntastyKit"
  s.version = "1.3.0"
  s.summary = "A collection of Swift utilities and protocols used in our projects."
  s.description = <<-DESC
     MVVM-C architecture, service holder for code injection of services
     some regularly used UIKit extensions, protocols for simple initialization from XIB files,
     storyboards and for handling keyboard, hairline and keyboard height constraints
  DESC
  s.homepage = "https://github.com/thefuntasty/FuntastyKit"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Matěj K. Jirásek" => "matej.jirasek@thefuntasty.com" }
  s.social_media_url = "https://twitter.com/TheFuntasty"
  s.ios.deployment_target = "9.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source = { :git => "https://github.com/thefuntasty/FuntastyKit.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*"
  s.ios.frameworks = "Foundation", "UIKit"
  s.tvos.frameworks = "Foundation", "UIKit"
  s.watchos.frameworks = "Foundation", "UIKit"
  s.macos.frameworks = "Foundation"
end
