// swift-tools-version:5.7

//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "SpeziFHIR",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "SpeziFHIR", targets: ["SpeziFHIR"]),
        .library(name: "SpeziMockWebService", targets: ["SpeziMockWebService"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/FHIRModels", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/StanfordSpezi/Spezi", .upToNextMinor(from: "0.7.0")),
        .package(url: "https://github.com/StanfordSpezi/SpeziViews", .upToNextMinor(from: "0.4.0"))
    ],
    targets: [
        .target(
            name: "SpeziFHIR",
            dependencies: [
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "ModelsR4", package: "FHIRModels")
            ]
        ),
        .testTarget(
            name: "SpeziFHIRTests",
            dependencies: [
                .target(name: "SpeziFHIR")
            ]
        ),
        .target(
            name: "SpeziMockWebService",
            dependencies: [
                .target(name: "SpeziFHIR"),
                .product(name: "Spezi", package: "Spezi"),
                .product(name: "SpeziViews", package: "SpeziViews")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
