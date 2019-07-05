// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "FuntastyKit",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "FuntastyKit",
            targets: ["FuntastyKit"])
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.33.0")
    ],
    targets: [
        .target(
            name: "FuntastyKit",
            dependencies: []),
        .testTarget(
            name: "FuntastyKitTests",
            dependencies: ["FuntastyKit"])
    ]
)
