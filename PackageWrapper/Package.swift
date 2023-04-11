// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PackageWrapper",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(
            name: "PackageWrapper",
            targets: ["PackageWrapper"]
        )
    ],
    dependencies: [
        // Uncomment to develop against local package
//        .package(path: "../../ViewStateController")
        .package(url: "https://github.com/mdb1/ViewStateController", from: "0.0.8")
    ],
    targets: [
        .target(
            name: "PackageWrapper",
            dependencies: ["ViewStateController"]
        ),
        .testTarget(
            name: "PackageWrapperTests",
            dependencies: ["PackageWrapper"]
        )
    ]
)
