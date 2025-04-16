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
