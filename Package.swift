// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "FuntastyKit",
    platforms: [.iOS(.v9)],
    products: [
        .library(
            name: "FuntastyKit",
            targets: ["FuntastyKit"]),
        .library(
            name: "FuntastyKitIBInspectable",
            targets: ["FuntastyKitIBInspectable"])
    ],
    targets: [
        .target(
            name: "FuntastyKit",
            dependencies: []),
        .target(
            name: "FuntastyKitIBInspectable",
            dependencies: []),
        .testTarget(
            name: "FuntastyKitTests",
            dependencies: ["FuntastyKit"])
    ]
)
