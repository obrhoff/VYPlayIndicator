// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "VYPlayIndicator",
    platforms: [
        .iOS(.v10), .macOS(.v10_12), .tvOS(.v10),
    ],
    products: [
        .library(
            name: "VYPlayIndicator",
            targets: ["VYPlayIndicator"]
        ),
    ],
    targets: [
        .target(
            name: "VYPlayIndicator"
        ),
    ]
)
