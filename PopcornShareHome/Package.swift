// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

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
        .package(path: "PopcornShareUtilities"),
        .package(path: "PopcornShareNetwork/PopcornShareNetwork")
    ],
    targets: [
        .target(
            name: "PopcornShareHome",
            dependencies: [
                .product(name: "PopcornShareUtilities", package: "PopcornShareUtilities"),
                .product(name: "PopcornShareNetwork", package: "PopcornShareNetwork")
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
