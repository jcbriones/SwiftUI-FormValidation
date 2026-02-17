// swift-tools-version: 6.0
import PackageDescription

let package = Package(
    name: "SwiftUIFormValidation",
    defaultLocalization: "en",
    platforms: [
        .macOS(.v14), .iOS(.v17), .tvOS(.v17)
    ],
    products: [
        .library(
            name: "SwiftUIFormValidation",
            targets: ["SwiftUIFormValidation"])
    ],
    dependencies: [
        .package(url: "https://github.com/tevelee/SwiftUI-Flow.git", from: "3.1.0"),
        .package(url: "https://github.com/nalexn/ViewInspector.git", from: "0.10.3")
    ],
    targets: [
        .target(
            name: "SwiftUIFormValidation",
            dependencies: [
                .product(name: "Flow", package: "SwiftUI-Flow")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SwiftUIFormValidationTests",
            dependencies: [
                "SwiftUIFormValidation",
                .product(name: "ViewInspector", package: "ViewInspector")
            ]
        )
    ]
)
