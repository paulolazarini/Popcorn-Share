// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornShareHome",
    platforms: [
        .iOS(.v17)
    ],
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
