// swift-tools-version: 5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Permissions",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "Permissions",
            targets: ["Permissions"]
        )
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Permissions",
            dependencies: []
        ),
        .testTarget(
            name: "PermissionsTests",
            dependencies: ["Permissions"]
        )
    ]
)
