// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "PopcornShareProfile",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "PopcornShareProfile",
            targets: ["PopcornShareProfile"])
    ],
    dependencies: [
        .package(path: "PopcornShareUtilities"),
        .package(path: "PopcornShareNetwork/PopcornShareNetwork")
    ],
    targets: [
        .target(
            name: "PopcornShareProfile",
            dependencies: [
                .product(name: "PopcornShareUtilities", package: "PopcornShareUtilities"),
                .product(name: "PopcornShareNetwork", package: "PopcornShareNetwork")
            ],
            path: "Sources/"
//            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "PopcornShareProfileTests",
            dependencies: ["PopcornShareProfile"]
        ),
    ]
)
