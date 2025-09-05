// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornShareProfile",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "PopcornShareProfile",
            targets: ["PopcornShareProfile"])
    ],
    dependencies: [
        .package(path: "../SupportPackages/PopcornShareUtilities"),
        .package(path: "../NetworkPackages/PopcornShareFirebase")
    ],
    targets: [
        .target(
            name: "PopcornShareProfile",
            dependencies: [
                "PopcornShareUtilities",
                "PopcornShareFirebase"
            ],
            path: "Sources/"
        ),
        .testTarget(
            name: "PopcornShareProfileTests",
            dependencies: ["PopcornShareProfile"]
        ),
    ]
)
