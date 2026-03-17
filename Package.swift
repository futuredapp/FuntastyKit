// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "FuntastyKit",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "FuntastyKit", targets: ["FuntastyKit"])
    ],
    targets: [
        .target(name: "FuntastyKit"),
        .testTarget(name: "FuntastyKitTests", dependencies: ["FuntastyKit"])
    ]
)
