// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornShareNetwork",
    platforms: [
        .iOS(.v18)
    ],
    products: [
        .library(
            name: "PopcornShareNetwork",
            targets: ["PopcornShareNetwork"]),
    ],
    dependencies: [
        .package(path: "PopcornShareNetworkCore")
    ],
    targets: [
        .target(
            name: "PopcornShareNetwork",
            dependencies: [
                .product(name: "PopcornShareNetworkCore", package: "PopcornShareNetworkCore"),
                "PopcornShareNetworkModel"
            ],
            path: "Sources/Network"
        ),
        .target(
            name: "PopcornShareNetworkModel",
            path: "Sources/Model"
        )
    ]
)
