// swift-tools-version:5.9

//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "SpeziFHIR",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v17)
    ],
    products: [
        .library(name: "SpeziFHIR", targets: ["SpeziFHIR"]),
        .library(name: "SpeziFHIRHealthKit", targets: ["SpeziFHIRHealthKit"]),
        .library(name: "SpeziFHIRInterpretation", targets: ["SpeziFHIRInterpretation"]),
        .library(name: "SpeziFHIRMockPatients", targets: ["SpeziFHIRMockPatients"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/FHIRModels", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/StanfordBDHG/HealthKitOnFHIR", .upToNextMinor(from: "0.2.4")),
        .package(url: "https://github.com/StanfordSpezi/Spezi", from: "1.1.0"),
        .package(url: "https://github.com/StanfordSpezi/SpeziHealthKit.git", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/StanfordSpezi/SpeziLLM.git", .upToNextMinor(from: "0.6.0")),
        .package(url: "https://github.com/StanfordSpezi/SpeziStorage.git", from: "1.0.0"),
        .package(url: "https://github.com/StanfordSpezi/SpeziChat.git", .upToNextMinor(from: "0.1.4"))
    ],
    targets: [
        .target(
            name: "SpeziFHIR",
            dependencies: [
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "ModelsDSTU2", package: "FHIRModels"),
                .product(name: "HealthKitOnFHIR", package: "HealthKitOnFHIR")
            ]
        ),
        .target(
            name: "SpeziFHIRHealthKit",
            dependencies: [
                .target(name: "SpeziFHIR"),
                .product(name: "HealthKitOnFHIR", package: "HealthKitOnFHIR"),
                .product(name: "SpeziHealthKit", package: "SpeziHealthKit")
            ]
        ),
        .target(
            name: "SpeziFHIRInterpretation",
            dependencies: [
                .target(name: "SpeziFHIR"),
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "SpeziLLM", package: "SpeziLLM"),
                .product(name: "SpeziLLMOpenAI", package: "SpeziLLM"),
                .product(name: "SpeziLocalStorage", package: "SpeziStorage"),
                .product(name: "SpeziChat", package: "SpeziChat")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .target(
            name: "SpeziFHIRMockPatients",
            dependencies: [
                .target(name: "SpeziFHIR")
            ],
            resources: [
                .process("Resources")
            ]
        ),
        .testTarget(
            name: "SpeziFHIRTests",
            dependencies: [
                .target(name: "SpeziFHIR")
            ]
        )
    ]
)
