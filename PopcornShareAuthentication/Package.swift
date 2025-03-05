// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "PopcornShareAuthentication",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "PopcornShareAuthentication",
            targets: ["PopcornShareAuthentication"])
    ],
    dependencies: [
        .package(path: "PopcornShareUtilities"),
        .package(path: "PopcornShareNetwork/PopcornShareNetwork")
    ],
    targets: [
        .target(
            name: "PopcornShareAuthentication",
            dependencies: [
                .product(name: "PopcornShareUtilities", package: "PopcornShareUtilities"),
                .product(name: "PopcornShareNetwork", package: "PopcornShareNetwork")
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
