// swift-tools-version:5.8

//
// This source file is part of the CardinalKit open-source project
//
// SPDX-FileCopyrightText: 2022 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import PackageDescription


let package = Package(
    name: "CardinalKitFHIR",
    defaultLocalization: "en",
    platforms: [
        .iOS(.v16)
    ],
    products: [
        .library(name: "CardinalKitFHIR", targets: ["CardinalKitFHIR"]),
        .library(name: "CardinalKitFHIRMockDataStorageProvider", targets: ["CardinalKitFHIRMockDataStorageProvider"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/FHIRModels", .upToNextMinor(from: "0.5.0")),
        .package(url: "https://github.com/StanfordBDHG/CardinalKit", .upToNextMinor(from: "0.4.0")),
        .package(url: "https://github.com/StanfordBDHG/CardinalKitViews", .upToNextMinor(from: "0.2.0"))
    ],
    targets: [
        .target(
            name: "CardinalKitFHIR",
            dependencies: [
                .product(name: "CardinalKit", package: "CardinalKit"),
                .product(name: "ModelsR4", package: "FHIRModels")
            ]
        ),
        .testTarget(
            name: "CardinalKitFHIRTests",
            dependencies: [
                .target(name: "CardinalKitFHIR")
            ]
        ),
        .target(
            name: "CardinalKitFHIRMockDataStorageProvider",
            dependencies: [
                .target(name: "CardinalKitFHIR"),
                .product(name: "CardinalKit", package: "CardinalKit"),
                .product(name: "CardinalKitViews", package: "CardinalKitViews")
            ],
            resources: [
                .process("Resources")
            ]
        )
    ]
)
