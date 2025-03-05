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
        .package(path: "PopcornShareNetwork/PopcornShareNetwork"),
        .package(path: "PopcornShareNetwork/PopcornShareFirebase")
    ],
    targets: [
        .target(
            name: "PopcornShareUtilities",
            dependencies: [
                .product(
                    name: "PopcornShareNetwork",
                    package: "PopcornShareNetwork"
                ),
                .product(
                    name: "PopcornShareFirebase",
                    package: "PopcornShareFirebase"
                )
            ]
        )
    ]
)
