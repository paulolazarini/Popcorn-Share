// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "PopcornShareHome",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "PopcornShareHome",
            targets: ["PopcornShareHome"])
    ],
    dependencies: [
        .package(path: "../SupportPackages/PopcornShareUtilities"),
        .package(path: "../NetworkPackages/PopcornShareNetwork")
    ],
    targets: [
        .target(
            name: "PopcornShareHome",
            dependencies: [
                "PopcornShareUtilities",
                "PopcornShareNetwork"
            ],
            path: "Sources/",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "PopcornShareHomeTests",
            dependencies: ["PopcornShareHome"]
        ),
    ]
)
