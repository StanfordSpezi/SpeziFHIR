//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import class ModelsR4.Bundle


extension ModelsR4.Bundle {
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Jamison785 Denesik803.
    public static let jamison785Denesik803: Bundle = Foundation.Bundle.module.loadFHIRBundle(
        withName: "Jamison785_Denesik803_1e08cb3f-9e6a-b083-b6ee-0bb38f70ba50"
    )
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Maye976 Dickinson688.
    public static let maye976Dickinson688: Bundle = Foundation.Bundle.module.loadFHIRBundle(
        withName: "Maye976_Dickinson688_04f25f73-04b2-469c-3806-540417a0d61c"
    )
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Milagros256 Hills818.
    public static let milagros256Hills818: Bundle = Foundation.Bundle.module.loadFHIRBundle(
        withName: "Milagros256_Hills818_79b1d90a-0eaf-be78-9bbf-91c638626012"
    )
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Napoleon578 Fay398.
    public static let napoleon578Fay398: Bundle = Foundation.Bundle.module.loadFHIRBundle(
        withName: "Napoleon578_Fay398_38f38890-b80f-6542-51d4-882c7b37b0bf"
    )
    
    
    /// Loads example FHIR resources packed into a bundle to represent the simulated patients.
    public static let mockPatients: [Bundle] = [
        .jamison785Denesik803,
        .maye976Dickinson688,
        .milagros256Hills818,
        .napoleon578Fay398
    ]
}
