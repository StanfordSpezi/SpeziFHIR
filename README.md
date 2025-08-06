<!--

This source file is part of the Stanford Spezi open-source project.

SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)

SPDX-License-Identifier: MIT
  
-->

# Spezi FHIR

[![Build and Test](https://github.com/StanfordSpezi/SpeziFHIR/actions/workflows/build-and-test.yml/badge.svg)](https://github.com/StanfordSpezi/SpeziFHIR/actions/workflows/build-and-test.yml)
[![codecov](https://codecov.io/gh/StanfordSpezi/SpeziFHIR/branch/main/graph/badge.svg?token=zVpvbIrHL6)](https://codecov.io/gh/StanfordSpezi/SpeziFHIR)
[![DOI](https://zenodo.org/badge/DOI/10.5281/zenodo.7803123.svg)](https://doi.org/10.5281/zenodo.7803123)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStanfordSpezi%2FSpeziFHIR%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/StanfordSpezi/SpeziFHIR)
[![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2FStanfordSpezi%2FSpeziFHIR%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/StanfordSpezi/SpeziFHIR)

Build FHIR-based healthcare applications with Spezi.

## Overview

The Spezi FHIR Swift Package provides essential building blocks for developing FHIR-based mobile healthcare applications using the Spezi framework. It includes comprehensive tools for FHIR resource management, HealthKit integration, and mock patient data for testing and development.

## Setup

### Add SpeziFHIR as a Dependency

You need to add the SpeziFHIR Swift package to
[your app in Xcode](https://developer.apple.com/documentation/xcode/adding-package-dependencies-to-your-app#) or
[Swift package](https://developer.apple.com/documentation/xcode/creating-a-standalone-swift-package-with-xcode#Add-a-dependency-on-another-Swift-package).

> [!IMPORTANT]  
> If your application is not yet configured to use Spezi, follow the [Spezi setup article](https://swiftpackageindex.com/stanfordspezi/spezi/documentation/spezi/initial-setup) to set up the core Spezi infrastructure.


## Targets

Spezi FHIR provides a number of targets to help developers integrate FHIR functionality in their Spezi-based applications:

- [`SpeziFHIR`](https://swiftpackageindex.com/stanfordspezi/spezifhir/documentation/spezifhir): Core FHIR resource management, storage, and utilities for working with FHIR R4 and DSTU2 resources.
- [`SpeziFHIRHealthKit`](https://swiftpackageindex.com/stanfordspezi/spezifhir/documentation/spezifhirhealthkit): Seamless integration between HealthKit data and FHIR resources, enabling conversion of health data to FHIR format.
- [`SpeziFHIRMockPatients`](https://swiftpackageindex.com/stanfordspezi/spezifhir/documentation/spezifhirmockpatients): Mock patient data and FHIR bundles for testing and development purposes.

### SpeziFHIR

The core module provides essential FHIR functionality including the `FHIRStore`, an observable store for managing and organizing FHIR resources by category. The `FHIRResource` type serves as a wrapper for FHIR resources with additional metadata and utilities. Combined, they provide tools for searching, copying, and manipulating FHIR resources that are compatible with both FHIR R4 and DSTU2 specifications.

#### FHIRStore

Configure the `FHIRStore` in your `SpeziAppDelegate` to manage FHIR resources in your application:

```swift
import Spezi
import SpeziFHIR

class ExampleAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration {
            FHIRStore()
        }
    }
}
```

Use the `FHIRStore` to manage FHIR resources in your application:

```swift
import SpeziFHIR
import SwiftUI

struct ExampleView: View {
    @Environment(FHIRStore.self) private var fhirStore
    
    var body: some View {
        List {
            Section("Observations") {
                ForEach(fhirStore.observations) { observation in
                    Text(observation.displayName)
                }
            }
            
            Section("Conditions") {
                ForEach(fhirStore.conditions) { condition in
                    Text(condition.displayName)
                }
            }
        }
    }
}
```

Load FHIR bundles and work with individual resources:

```swift
import ModelsR4
import SpeziFHIR

// Load a FHIR bundle
await fhirStore.load(bundle: fhirBundle)

// Create and insert individual resources
let observation = Observation(/* FHIR observation data */)
let fhirResource = FHIRResource(resource: observation, displayName: "Blood Pressure")
fhirStore.insert(resource: fhirResource)

// Search and filter resources
let recentObservations = fhirStore.observations.filter { observation in
    // Filter logic
}
```

### SpeziFHIRHealthKit

Seamlessly integrate HealthKit data with FHIR resources:

#### Setup

Ensure your app is configured to use both SpeziHealthKit and SpeziFHIR:

```swift
import SpeziHealthKit
import SpeziFHIR
import SpeziFHIRHealthKit

class ExampleAppDelegate: SpeziAppDelegate {
    override var configuration: Configuration {
        Configuration(standard: ExampleStandard()) {
            FHIRStore()
            HealthKit {
                CollectSample(.heartRate)
                CollectSample(.stepCount)
                // Configure other HealthKit data collection
            }
        }
    }
}
```

#### Usage

Convert HealthKit samples to FHIR resources:

```swift
import HealthKit
import SpeziFHIRHealthKit

// Convert HealthKit samples to FHIR observations
let healthKitSamples: [HKQuantitySample] = // Your HealthKit data
let fhirObservations = healthKitSamples.map { sample in
    sample.fhirR4Observation() // Convert to FHIR R4 Observation
}

// Add to FHIR store
for observation in fhirObservations {
    let fhirResource = FHIRResource(resource: observation, displayName: "HealthKit Data")
    fhirStore.insert(resource: fhirResource)
}
```

### SpeziFHIRMockPatients

Use mock patient data for testing and development:

#### Usage

Load mock patient bundles for testing:

```swift
import SpeziFHIRMockPatients

// Load a random mock patient bundle
let mockBundle = FHIRBundleSelector().randomPatient
await fhirStore.load(bundle: mockBundle)

// Or select a specific mock patient
let specificPatient = FHIRBundleSelector().mockPatients.first
await fhirStore.load(bundle: specificPatient)
```

Use in your test setup:

```swift
import Testing
import SpeziFHIRMockPatients

@Test
func testFHIRFunctionality() async throws {
    let fhirStore = FHIRStore()
    await fhirStore.loadMockPatients()
    
    #expect(!fhirStore.observations.isEmpty)
    #expect(!fhirStore.conditions.isEmpty)
}
```

## The Spezi Template Application

The [Spezi Template Application](https://github.com/StanfordSpezi/SpeziTemplateApplication) provides a great starting point and example using the SpeziFHIR modules.

For more information, please refer to the [API documentation](https://swiftpackageindex.com/StanfordSpezi/SpeziFHIR/documentation).

## Contributing

Contributions to this project are welcome. Please make sure to read the [contribution guidelines](https://github.com/StanfordSpezi/.github/blob/main/CONTRIBUTING.md) and the [contributor covenant code of conduct](https://github.com/StanfordSpezi/.github/blob/main/CODE_OF_CONDUCT.md) first.

## License

This project is licensed under the MIT License. See [Licenses](https://github.com/StanfordSpezi/SpeziFHIR/tree/main/LICENSES) for more information.

![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/FooterLight.png#gh-light-mode-only)
![Spezi Footer](https://raw.githubusercontent.com/StanfordSpezi/.github/main/assets/FooterDark.png#gh-dark-mode-only)
