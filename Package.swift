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
        .package(url: "https://github.com/StanfordSpezi/Spezi", .upToNextMinor(from: "0.8.0")),
        .package(url: "https://github.com/StanfordSpezi/SpeziHealthKit.git", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/StanfordSpezi/SpeziML.git", .upToNextMinor(from: "0.3.1"))
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
                .product(name: "SpeziOpenAI", package: "SpeziML")
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
