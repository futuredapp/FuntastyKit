Pod::Spec.new do |s|
  s.name = "FuntastyKit"
  s.version = "1.1.2"
  s.summary = "A collection of Swift utilities and protocols used in our projects."
  s.description = <<-DESC
     A collection of Swift utilities and protocols used in our projects.
  DESC
  s.homepage = "https://github.com/thefuntasty/FuntastyKit"
  s.license = { :type => "MIT", :file => "LICENSE" }
  s.author = { "Petr Zvonicek" => "" }
  s.social_media_url = "https://twitter.com/TheFuntasty"
  s.ios.deployment_target = "8.0"
  s.osx.deployment_target = "10.9"
  s.watchos.deployment_target = "2.0"
  s.tvos.deployment_target = "9.0"
  s.source = { :git => "https://github.com/thefuntasty/FuntastyKit.git", :tag => s.version.to_s }
  s.source_files = "Sources/**/*"
  s.frameworks = "Foundation"
end
