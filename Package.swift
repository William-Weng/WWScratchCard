// swift-tools-version: 5.6
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WWScratchCard",
    platforms: [
        .iOS(.v14)
    ],
    products: [
        .library(name: "WWScratchCard", targets: ["WWScratchCard"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(name: "WWScratchCard"),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
