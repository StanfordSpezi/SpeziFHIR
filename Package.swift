// swift-tools-version:6.2
//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import class Foundation.ProcessInfo
import PackageDescription

let enableSwiftLintPlugin = false

let defaultSwiftSettings: [SwiftSetting] = [
    .enableUpcomingFeature("ExistentialAny"),
    .enableUpcomingFeature("InternalImportsByDefault")
]


let package = Package(
    name: "SpeziFHIR",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17),
        .macOS(.v14),
        .watchOS(.v10),
        .visionOS(.v1)
    ],
    products: [
        .library(name: "SpeziFHIR", targets: ["SpeziFHIR"]),
        .library(name: "FHIRModelsExtensions", targets: ["FHIRModelsExtensions"]),
        .library(name: "FHIRPathParser", targets: ["FHIRPathParser"]),
        .library(name: "FHIRQuestionnaires", targets: ["FHIRQuestionnaires"])
    ],
    dependencies: [
//        .package(url: "https://github.com/apple/FHIRModels.git", .upToNextMinor(from: "0.9.0")),
        .package(url: "https://github.com/lukaskollmer/FHIRModels.git", branch: "lukas/try-to-fix"),
        .package(url: "https://github.com/StanfordSpezi/Spezi.git", from: "1.8.0"),
        .package(url: "https://github.com/antlr/antlr4.git", from: "4.13.1")
    ] + swiftLintPackage,
    targets: [
        .target(
            name: "SpeziFHIR",
            dependencies: [
                "FHIRModelsExtensions",
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "ModelsDSTU2", package: "FHIRModels")
            ],
            swiftSettings: defaultSwiftSettings,
            plugins: [] + swiftLintPlugin
        ),
        .target(
            name: "FHIRModelsExtensions",
            dependencies: [
                "FHIRPathParser",
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "ModelsDSTU2", package: "FHIRModels")
            ],
            swiftSettings: defaultSwiftSettings,
            plugins: [] + swiftLintPlugin
        ),
        .target(
            name: "FHIRPathParser",
            dependencies: [
                .product(name: "Antlr4", package: "antlr4")
            ],
            exclude: [
                "ANTLUtils"
            ]
        ),
        .target(
            name: "FHIRQuestionnaires",
            dependencies: [
                .product(name: "ModelsR4", package: "FHIRModels")
            ],
            resources: [.process("Resources")],
            swiftSettings: defaultSwiftSettings,
            plugins: [] + swiftLintPlugin
        ),
        .testTarget(
            name: "SpeziFHIRTests",
            dependencies: [
                "SpeziFHIR"
            ],
            swiftSettings: defaultSwiftSettings,
            plugins: [] + swiftLintPlugin
        ),
        .testTarget(
            name: "FHIRModelsExtensionsTests",
            dependencies: [
                "FHIRModelsExtensions", "FHIRQuestionnaires"
            ],
            swiftSettings: defaultSwiftSettings,
            plugins: [] + swiftLintPlugin
        ),
        .testTarget(
            name: "FHIRPathParserTests",
            dependencies: ["FHIRPathParser"],
            swiftSettings: defaultSwiftSettings,
            plugins: [] + swiftLintPlugin
        )
    ]
)


// MARK: SwiftLint support

var swiftLintPlugin: [Target.PluginUsage] {
    if enableSwiftLintPlugin {
        [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLintPlugins")]
    } else {
        []
    }
}

var swiftLintPackage: [PackageDescription.Package.Dependency] {
    if enableSwiftLintPlugin {
        [.package(url: "https://github.com/SimplyDanny/SwiftLintPlugins.git", from: "0.63.2")]
    } else {
        []
    }
}
