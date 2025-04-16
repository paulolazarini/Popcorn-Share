// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "PopcornShareSearch",
    platforms: [.iOS(.v18)],
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
