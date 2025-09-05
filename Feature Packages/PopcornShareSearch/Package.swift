// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornShareSearch",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "PopcornShareSearch",
            targets: ["PopcornShareSearch"])
    ],
    dependencies: [
        .package(path: "../SupportPackages/PopcornShareUtilities"),
        .package(path: "../NetworkPackages/PopcornShareNetwork")
    ],
    targets: [
        .target(
            name: "PopcornShareSearch",
            dependencies: [
                "PopcornShareUtilities",
                "PopcornShareNetwork"
            ],
            path: "Sources/"
//            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "PopcornShareSearchTests",
            dependencies: ["PopcornShareSearch"]
        ),
    ]
)
