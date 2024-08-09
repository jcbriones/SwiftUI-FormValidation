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
            dependencies: []
//            swiftSettings: swiftSettings
        ),
        .testTarget(
            name: "SwiftUIFormValidationTests",
            dependencies: ["SwiftUIFormValidation"]
//            swiftSettings: swiftSettings
        )
    ]
)
var swiftSettings: [SwiftSetting] {
    [
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_FORWARD_TRAILING_CLOSURES"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_IMPLICIT_OPEN_EXISTENTIALS"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_IMPORT_OBJC_FORWARD_DECLS"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_ISOLATED_DEFAULT_VALUES"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_GLOBAL_CONCURRENCY"),
        .enableUpcomingFeature("SWIFT_UPCOMING_FEATURE_EXISTENTIAL_ANY")
    ]
}
