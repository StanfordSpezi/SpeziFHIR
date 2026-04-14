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
        .package(url: "https://github.com/apple/FHIRModels.git", "0.8.0"..<"0.9.0"),
        .package(url: "https://github.com/StanfordSpezi/Spezi.git", from: "1.8.0"),
        .package(url: "https://github.com/antlr/antlr4.git", from: "4.13.1")
    ],
    targets: [
        .target(
            name: "SpeziFHIR",
            dependencies: [
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "ModelsR4", package: "FHIRModels"),
                .product(name: "ModelsDSTU2", package: "FHIRModels"),
            ],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
        ),
        .target(
            name: "FHIRModelsExtensions",
            dependencies: [
                "FHIRPathParser",
                .product(name: "ModelsR4", package: "FHIRModels")
            ],
            swiftSettings: [
                .enableUpcomingFeature("ExistentialAny"),
                .enableUpcomingFeature("InternalImportsByDefault")
            ]
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
            resources: [.process("Resources")]
        ),
        .testTarget(
            name: "SpeziFHIRTests",
            dependencies: [
                "SpeziFHIR"
            ],
            swiftSettings: [.enableUpcomingFeature("ExistentialAny")]
        ),
        .testTarget(
            name: "FHIRModelsExtensionsTests",
            dependencies: [
                "FHIRModelsExtensions", "FHIRQuestionnaires"
            ]
        ),
        .testTarget(
            name: "FHIRPathParserTests",
            dependencies: ["FHIRPathParser"]
        )
    ]
)
