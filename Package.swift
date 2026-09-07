// swift-tools-version: 6.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ApiState",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(
            name: "ApiState",
            targets: ["ApiState"]
        ),
    ],
    targets: [
        .target(
            name: "ApiState"
        ),

    ],
    swiftLanguageModes: [.v6]
)
