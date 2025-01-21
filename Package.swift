// swift-tools-version: 6.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PhotoPickerSwiftUI",
    platforms: [.iOS(.v17)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "PhotoPickerSwiftUI",
            targets: ["PhotoPickerSwiftUI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/guoyingtao/Mantis.git", exact: "2.23.1")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "PhotoPickerSwiftUI",
            dependencies: [
                .product(name: "Mantis", package: "Mantis"),
            ],
            path: "Sources",
            resources: [
                .process("Resource/Media.xcassets") // Include resources folder
            ]
        ),
        .testTarget(
            name: "PhotoPickerSwiftUITests",
            dependencies: ["PhotoPickerSwiftUI"]
        ),
    ]
)
