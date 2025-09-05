// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornShareUtilities",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "PopcornShareUtilities",
            targets: ["PopcornShareUtilities"]),
    ],
    dependencies: [
        .package(path: "../NetworkPackages/PopcornShareNetwork"),
        .package(path: "../NetworkPackages/PopcornShareFirebase")
    ],
    targets: [
        .target(
            name: "PopcornShareUtilities",
            dependencies: [
                "PopcornShareNetwork",
                "PopcornShareFirebase"
            ]
        )
    ]
)
