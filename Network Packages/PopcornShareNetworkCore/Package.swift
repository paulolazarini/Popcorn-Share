// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PopcornShareNetworkCore",
    platforms: [.iOS(.v18)],
    products: [
        .library(
            name: "PopcornShareNetworkCore",
            targets: ["PopcornShareNetworkCore"]),
    ],
    targets: [
        .target(
            name: "PopcornShareNetworkCore"),
    ]
)
