Pod::Spec.new do |s|
  s.name = "FuntastyKit"
  s.version = "2.2.2"
  s.summary = "A collection of Swift utilities and protocols used in our projects."
  s.description = <<-DESC
     MVVM-C architecture, service holder for code injection of services
     some regularly used UIKit extensions, protocols for simple initialization from XIB files,
     storyboards and for handling keyboard, hairline and keyboard height constraints
  DESC
  s.homepage = "https://github.com/futuredapp/FuntastyKit"
  s.license = { type: "MIT", file: "LICENSE" }
  s.author = { "Matěj K. Jirásek" => "matej.jirasek@futured.app" }
  s.social_media_url = "https://twitter.com/Futuredapps"
  s.platform = :ios, "9.0"
  s.swift_version = "5.0"
  s.source = { :git => "https://github.com/futuredapp/FuntastyKit.git", :tag => s.version.to_s }
  s.frameworks = ["Foundation", "UIKit"]
  s.default_subspec = "Core"

  s.subspec "Core" do |ss|
    ss.source_files = Dir["Sources/FuntastyKit/*"]
  end

  s.subspec "IBInspectable" do |ss|
    ss.dependency "FuntastyKit/Core"
    ss.source_files = Dir["Sources/FuntastyKitIBInspectable/*"]
  end
end

