// swift-tools-version:5.2
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "AC_iOS_SDK",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        // Products define the executables and libraries produced by a package, and make them visible to other packages.
        .library(
            name: "AC_iOS_SDK",
            targets: ["AC_iOS_SDK"]),
    ],
    dependencies: [
        .package(name:"AC_iOS_AR", url: "https://github.com/vergendo-ac/AC_iOS_AR.git", from: "2.12.4"),
        .package(name:"AC_iOS_NET", url: "https://github.com/vergendo-ac/AC_iOS_NET.git", from: "2.12.18")
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages which this package depends on.
        .target(
            name: "AC_iOS_SDK",
            dependencies: ["AC_iOS_NET", "AC_iOS_AR"]),
        .testTarget(
            name: "AC_iOS_SDKTests",
            dependencies: ["AC_iOS_SDK"]),
    ]
)
