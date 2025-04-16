// swift-tools-version:6.0
import PackageDescription

let package = Package(
    name: "PopcornShareFirebase",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "PopcornShareFirebase",
            targets: ["PopcornShareFirebase"])
    ],
    dependencies: [
        .package(url: "https://github.com/firebase/firebase-ios-sdk.git", from: "10.15.0")
    ],
    targets: [
        .target(
            name: "PopcornShareFirebase",
            dependencies: [
                .product(name: "FirebaseAuth", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestore", package: "firebase-ios-sdk"),
                .product(name: "FirebaseFirestoreSwift", package: "firebase-ios-sdk")
            ],
            path: "Sources/"
        )
    ]
)
