// swift-tools-version: 5.8

import PackageDescription

let package = Package(
    name: "SwiftUIFormValidation",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v13), .iOS(.v16), .tvOS(.v16)
    ],
    products: [
        .library(
            name: "SwiftUIFormValidation",
            targets: ["SwiftUIFormValidation"])
    ],
    dependencies: [
        // Dependencies declare other packages that this package depends on.
        // .package(url: /* package url */, from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftUIFormValidation",
            dependencies: []),
        .testTarget(
            name: "SwiftUIFormValidationTests",
            dependencies: ["SwiftUIFormValidation"])
    ]
)
