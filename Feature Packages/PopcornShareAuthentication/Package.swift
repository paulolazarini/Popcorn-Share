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
