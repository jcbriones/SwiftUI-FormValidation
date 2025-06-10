// swift-tools-version: 6.0
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
        .package(url: "https://github.com/tevelee/SwiftUI-Flow.git", from: "3.0.2")
    ],
    targets: [
        .target(
            name: "SwiftUIFormValidation",
            dependencies: [
                .product(name: "Flow", package: "SwiftUI-Flow")
            ]
        ),
        .testTarget(
            name: "SwiftUIFormValidationTests",
            dependencies: ["SwiftUIFormValidation"]
        )
    ]
)
