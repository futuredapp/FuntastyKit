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
            name: "FuntastyKitDesignables",
            targets: ["FuntastyKitDesignables"])
    ],
    targets: [
        .target(
            name: "FuntastyKit",
            dependencies: []),
        .target(
            name: "FuntastyKitDesignables",
            dependencies: []),
        .testTarget(
            name: "FuntastyKitTests",
            dependencies: ["FuntastyKit"])
    ]
)
