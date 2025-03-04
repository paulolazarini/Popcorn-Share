// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "PopcornShareUtilities",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "PopcornShareUtilities",
            targets: ["PopcornShareUtilities"]),
    ],
    dependencies: [
        .package(path: "PopcornShareNetwork/PopcornShareNetwork")
    ],
    targets: [
        .target(
            name: "PopcornShareUtilities",
            dependencies: [
                .product(
                    name: "PopcornShareNetwork",
                    package: "PopcornShareNetwork"
                )
            ]
        )
    ]
)
