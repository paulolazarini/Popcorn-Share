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
        .package(path: "PopcornShareNetwork/PopcornShareNetwork"),
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.15.0")
    ],
    targets: [
        .target(
            name: "PopcornShareAuthentication",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
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
