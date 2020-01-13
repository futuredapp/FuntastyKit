# FuntastyKit

![Cocoapods](https://img.shields.io/cocoapods/v/FuntastyKit.svg)
![Cocoapods platforms](https://img.shields.io/cocoapods/p/FuntastyKit.svg)
![License](https://img.shields.io/cocoapods/l/FuntastyKit.svg)
![Continuous integration](https://img.shields.io/bitrise/6f0c129e47a9b6f1.svg?token=Mfr5_Ek19pSrcZew0Pp9Bg)

FuntastyKit iOS framework contains:

- MVVM-C architecture used at [Futured](https://www.futured.app/en/), the template for this architecture can be found at https://github.com/thefuntasty/MVVM-C-Template
- Some regularly used UIKit extensions
- Protocols for simple initialization from XIB files, storyboards and for handling keyboard
- Hairline constraint for one-pixel designs

## Installation

If you want to use CocoaPods for dependency management, add following line to your `Podfile`:

```ruby
pod 'FuntastyKit', '~> 1.5'
```

For adding using Swift package manager either use Xcode or add following line to your `Package.swift` file:

```swift
.package(url: "https://github.com/thefuntasty/FuntastyKit.git", from: "0.5.0")
```

## Note on the name

The name of the framework comes from the name of our company before rebranding, Funtasty. Now, we are called Futured, but FuturedKit will be very probably based on SwiftUI instead of UIKit.

## Authors

If you have any question or issues, please contact the current maintainer:

- Matěj K. Jirásek, matej.jirasek@futured.app

Over the years many inside and outside contributors made improvements to this library, namely:

- [Petr Zvoníček](https://github.com/zvonicek)
- [Matěj K. Jirásek](https://github.com/mkj-is)
- [Patrik Potoček](https://github.com/Patrez)
- [Roman Podymov](https://github.com/RomanPodymov)
- [Radek Doležal](https://github.com/eRDe33)
- [Tomáš Babulák](https://github.com/tomasbabulak)
- [Mikoláš Stuchlík](https://github.com/mikolasstuchlik)
- [Marek Staňa](https://github.com/mstana)
- [Martin Pinka](https://github.com/crinos9)
- [Adam Bezák](https://github.com/bezoadam)

## License

FTTestingKit is available under the MIT license. See the [LICENSE file](LICENSE) for more info.
