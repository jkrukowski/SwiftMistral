// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swift-mistral",
    platforms: [
        .macOS(.v10_15),
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6)
    ],
    products: [
        .library(name: "SwiftMistral", targets: ["SwiftMistral"]),
        .executable(name: "swift-mistral", targets: ["SwiftMistralCLI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-openapi-generator", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-openapi-runtime", from: "1.0.0"),
        .package(url: "https://github.com/swift-server/swift-openapi-async-http-client", from: "1.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.50.4")
    ],
    targets: [
        .executableTarget(
            name: "SwiftMistralCLI",
            dependencies: [
                .target(name: "SwiftMistral"),
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime")
            ],
            plugins: [
                .plugin(
                    name: "SwiftFormat",
                    package: "SwiftFormat"
                )
            ]
        ),
        .target(
            name: "SwiftMistral",
            dependencies: [
                .product(name: "OpenAPIAsyncHTTPClient", package: "swift-openapi-async-http-client"),
                .product(name: "OpenAPIRuntime", package: "swift-openapi-runtime")
            ],
            resources: [
                .copy("openapi-generator-config.yaml"),
                .copy("openapi.yaml")
            ],
            plugins: [
                .plugin(
                    name: "OpenAPIGenerator",
                    package: "swift-openapi-generator"
                ),
                .plugin(
                    name: "SwiftFormat",
                    package: "SwiftFormat"
                )
            ]
        )
    ]
)
