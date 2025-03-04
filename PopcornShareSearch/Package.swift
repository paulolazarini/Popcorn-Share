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
        .package(path: "PopcornShareUtilities"),
        .package(path: "PopcornShareNetwork/PopcornShareNetwork")
    ],
    targets: [
        .target(
            name: "PopcornShareSearch",
            dependencies: [
                .product(name: "PopcornShareUtilities", package: "PopcornShareUtilities"),
                .product(name: "PopcornShareNetwork", package: "PopcornShareNetwork")
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
