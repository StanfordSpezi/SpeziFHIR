// swift-tools-version:5.9

//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import class Foundation.ProcessInfo
import PackageDescription


#if swift(<6)
let strictConcurrency: SwiftSetting = .enableExperimentalFeature("StrictConcurrency")
#else
let strictConcurrency: SwiftSetting = .enableUpcomingFeature("StrictConcurrency")
#endif

let package = Package(
    name: "SpeziFHIR",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "SpeziFHIR", targets: ["SpeziFHIR"]),
        .library(name: "SpeziFHIRHealthKit", targets: ["SpeziFHIRHealthKit"]),
        .library(name: "SpeziFHIRLLM", targets: ["SpeziFHIRLLM"]),
        .library(name: "SpeziFHIRMockPatients", targets: ["SpeziFHIRMockPatients"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/FHIRModels", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/StanfordBDHG/HealthKitOnFHIR", .upToNextMinor(from: "0.2.4")),
        .package(url: "https://github.com/StanfordSpezi/Spezi", from: "1.2.1"),
        .package(url: "https://github.com/StanfordSpezi/SpeziHealthKit.git", .upToNextMinor(from: "0.5.1")),
        .package(url: "https://github.com/StanfordSpezi/SpeziLLM.git", .upToNextMinor(from: "0.8.1")),
        .package(url: "https://github.com/StanfordSpezi/SpeziStorage.git", from: "1.0.0"),
        .package(url: "https://github.com/StanfordSpezi/SpeziChat.git", .upToNextMinor(from: "0.2.0")),
        .package(url: "https://github.com/StanfordSpezi/SpeziSpeech.git", from: "1.0.0")
    ] + swiftLintPackage(),
    targets: [
        .target(
            name: "SpeziFHIR",
            dependencies: [
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "ModelsDSTU2", package: "FHIRModels"),
                .product(name: "HealthKitOnFHIR", package: "HealthKitOnFHIR")
            ],
            swiftSettings: [
                strictConcurrency
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .target(
            name: "SpeziFHIRHealthKit",
            dependencies: [
                .target(name: "SpeziFHIR"),
                .product(name: "HealthKitOnFHIR", package: "HealthKitOnFHIR"),
                .product(name: "SpeziHealthKit", package: "SpeziHealthKit")
            ],
            swiftSettings: [
                strictConcurrency
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .target(
            name: "SpeziFHIRLLM",
            dependencies: [
                .target(name: "SpeziFHIR"),
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "SpeziLLM", package: "SpeziLLM"),
                .product(name: "SpeziLLMOpenAI", package: "SpeziLLM"),
                .product(name: "SpeziLocalStorage", package: "SpeziStorage"),
                .product(name: "SpeziChat", package: "SpeziChat"),
                .product(name: "SpeziSpeechSynthesizer", package: "SpeziSpeech")
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                strictConcurrency
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .target(
            name: "SpeziFHIRMockPatients",
            dependencies: [
                .target(name: "SpeziFHIR"),
                .product(name: "ModelsR4", package: "FHIRModels")
            ],
            resources: [
                .process("Resources")
            ],
            swiftSettings: [
                strictConcurrency
            ],
            plugins: [] + swiftLintPlugin()
        ),
        .testTarget(
            name: "SpeziFHIRTests",
            dependencies: [
                .target(name: "SpeziFHIR")
            ],
            swiftSettings: [
                strictConcurrency
            ],
            plugins: [] + swiftLintPlugin()
        )
    ]
)


func swiftLintPlugin() -> [Target.PluginUsage] {
    // Fully quit Xcode and open again with `open --env SPEZI_DEVELOPMENT_SWIFTLINT /Applications/Xcode.app`
    if ProcessInfo.processInfo.environment["SPEZI_DEVELOPMENT_SWIFTLINT"] != nil {
        [.plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint")]
    } else {
        []
    }
}

func swiftLintPackage() -> [PackageDescription.Package.Dependency] {
    if ProcessInfo.processInfo.environment["SPEZI_DEVELOPMENT_SWIFTLINT"] != nil {
        [.package(url: "https://github.com/realm/SwiftLint.git", .upToNextMinor(from: "0.55.1"))]
    } else {
        []
    }
}
