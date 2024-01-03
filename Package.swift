// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "BlazeFuse",
    platforms: [
        .macOS(.v14)
    ],
    dependencies: [
        .package(url: "https://github.com/hummingbird-project/hummingbird.git", .upToNextMajor(from: "1.11.0")),
        .package(url: "https://github.com/binarybirds/swift-html", from: "1.6.0"),
        .package(url: "https://github.com/hummingbird-project/hummingbird-fluent.git", .upToNextMajor(from: "1.1.0")),
        .package(url: "https://github.com/vapor/fluent-postgres-driver.git", from: "2.7.2"),
        .package(url: "https://github.com/vapor/multipart-kit.git", from: "4.0.0"),
    ],
    targets: [
        .executableTarget(
            name: "BlazeFuse",
            dependencies: [
                .product(name: "Hummingbird", package: "hummingbird"),
                .product(name: "HummingbirdFoundation", package: "hummingbird"),
                .product(name: "SwiftHtml", package: "swift-html"),
                .product(name: "HummingbirdFluent", package: "hummingbird-fluent"),
                .product(name: "FluentPostgresDriver", package: "fluent-postgres-driver"),
                .product(name: "MultipartKit", package: "multipart-kit"),
            ]
        )
    ]
)
