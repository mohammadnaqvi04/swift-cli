// swift-tools-version:5.0

import PackageDescription

let package = Package(
    name: "Tool",
    products: [
        .executable(name: "Tool", targets: ["Tool"]),
        .library(name: "ToolCore", targets: ["ToolCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/jpsim/SourceKitten", from: "0.19.1"),
        .package(url: "https://github.com/kylef/PathKit.git", from: "0.8.0"),
        .package(url: "https://github.com/kylef/Spectre.git", from: "0.8.0"),
        .package(url: "https://github.com/jakeheis/SwiftCLI", from: "5.1.0"),
    ],
    targets: [
        .target(
            name: "Tool",
            dependencies: [
                "ToolCLI",
            ]),
        .target(
            name: "ToolCLI",
            dependencies: [
                "ToolCore",
                "SwiftCLI",
            ]),
        .target(
            name: "ToolCore",
            dependencies: [
                "SourceKittenFramework",
                "PathKit",
                "SwiftCLI",
            ]),
        .testTarget(
            name: "ToolTests", 
            dependencies: [
                "ToolCore",
                "Spectre",
                "PathKit",
            ])
    ]
)
