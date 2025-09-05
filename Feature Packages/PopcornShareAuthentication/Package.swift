// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornShareAuthentication",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(
            name: "PopcornShareAuthentication",
            targets: ["PopcornShareAuthentication"])
    ],
    dependencies: [
        .package(path: "../SupportPackages/PopcornShareUtilities"),
        .package(path: "../NetworkPackages/PopcornShareNetwork")
    ],
    targets: [
        .target(
            name: "PopcornShareAuthentication",
            dependencies: [
                "PopcornShareUtilities",
                "PopcornShareNetwork"
            ],
            path: "Sources/",
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "PopcornShareAuthenticationTests",
            dependencies: ["PopcornShareAuthentication"]
        )
    ]
)
