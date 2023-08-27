// swift-tools-version: 5.8
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ReSwiftSaga",
    platforms: [.iOS("13.0")],
    products: [
        .library(
            name: "ReSwiftSaga",
            targets: ["ReSwiftSaga"]),
    ],
    dependencies: [
        .package(url: "https://github.com/ReSwift/ReSwift", .upToNextMajor(from: "6.1.0"))
    ],
    targets: [
        .target(
            name: "ReSwiftSaga",
            dependencies: ["ReSwift"]),
        .testTarget(
            name: "ReSwiftSagaTests",
            dependencies: ["ReSwiftSaga"]),
    ]
)
