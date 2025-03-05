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
        .package(path: "PopcornShareNetwork/PopcornShareFirebase")
    ],
    targets: [
        .target(
            name: "PopcornShareProfile",
            dependencies: [
                .product(name: "PopcornShareUtilities", package: "PopcornShareUtilities"),
                .product(name: "PopcornShareFirebase", package: "PopcornShareFirebase")
            ],
            path: "Sources/"
        ),
        .testTarget(
            name: "PopcornShareProfileTests",
            dependencies: ["PopcornShareProfile"]
        ),
    ]
)
