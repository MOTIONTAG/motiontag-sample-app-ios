// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "motiontag-sample-app-ios",
    platforms: [ .iOS(.v14) ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "motiontag-sample-app-ios",
            targets: ["motiontag-sample-app-ios"]),
    ],
     dependencies: [
        // Add MotionTagSDK as a dependency
        .package(url: "https://github.com/MOTIONTAG/motiontag-sdk-ios-releases", branch: "main"),
        //.package(url: "https://github.com/MOTIONTAG/motiontag-sdk-ios-internal-releases", branch: "master"),
//        .package(url: "https://github.com/MOTIONTAG/motiontag-sdk-ios.git", from: "5.0.5"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "motiontag-sample-app-ios",
            dependencies: ["MotionTagSDK"]), // Add the dependency here
        .testTarget(
            name: "motiontag-sample-app-iosTests",
            dependencies: ["motiontag-sample-app-ios"]),
    ]
)
