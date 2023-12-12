// swift-tools-version: 5.9

import PackageDescription

let package = Package(
    name: "swift-mistral",
    products: [
        .library(name: "SwiftMistral", targets: ["SwiftMistral"]),
        .executable(name: "swiftmistral", targets: ["SwiftMistralCLI"]),
    ],
    targets: [
        .executableTarget(
            name: "SwiftMistralCLI"
        ),
        .target(
            name: "SwiftMistral"
        )
    ]
)
