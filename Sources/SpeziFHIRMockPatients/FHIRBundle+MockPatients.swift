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
    private static var _jamison785Denesik803: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Jamison785 Denesik803.
    public static var jamison785Denesik803: ModelsR4.Bundle {
        get async {
            if let jamison785Denesik803 = _jamison785Denesik803 {
                return jamison785Denesik803
            }
            
            let jamison785Denesik803 = await Foundation.Bundle.module.loadFHIRBundle(
                withName: "Jamison785_Denesik803_1e08cb3f-9e6a-b083-b6ee-0bb38f70ba50"
            )
            ModelsR4.Bundle._jamison785Denesik803 = jamison785Denesik803
            return jamison785Denesik803
        }
    }
    
    private static var _maye976Dickinson688: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Maye976 Dickinson688.
    public static var maye976Dickinson688: ModelsR4.Bundle {
        get async {
            if let maye976Dickinson688 = _maye976Dickinson688 {
                return maye976Dickinson688
            }
            
            let maye976Dickinson688 = await Foundation.Bundle.module.loadFHIRBundle(
                withName: "Maye976_Dickinson688_04f25f73-04b2-469c-3806-540417a0d61c"
            )
            ModelsR4.Bundle._maye976Dickinson688 = maye976Dickinson688
            return maye976Dickinson688
        }
    }
    
    private static var _milagros256Hills818: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Milagros256 Hills818.
    public static var milagros256Hills818: ModelsR4.Bundle {
        get async {
            if let milagros256Hills818 = _milagros256Hills818 {
                return milagros256Hills818
            }
            
            let milagros256Hills818 = await Foundation.Bundle.module.loadFHIRBundle(
                withName: "Milagros256_Hills818_79b1d90a-0eaf-be78-9bbf-91c638626012"
            )
            ModelsR4.Bundle._milagros256Hills818 = milagros256Hills818
            return milagros256Hills818
        }
    }
    
    private static var _napoleon578Fay398: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Napoleon578 Fay398.
    public static var napoleon578Fay398: ModelsR4.Bundle {
        get async {
            if let napoleon578Fay398 = _napoleon578Fay398 {
                return napoleon578Fay398
            }
            
            let napoleon578Fay398 = await Foundation.Bundle.module.loadFHIRBundle(
                withName: "Napoleon578_Fay398_38f38890-b80f-6542-51d4-882c7b37b0bf"
            )
            ModelsR4.Bundle._napoleon578Fay398 = napoleon578Fay398
            return napoleon578Fay398
        }
    }
    
    
    /// Loads example FHIR resources packed into a bundle to represent the simulated patients.
    public static var mockPatients: [Bundle] {
        get async {
            await [
                .jamison785Denesik803,
                .maye976Dickinson688,
                .milagros256Hills818,
                .napoleon578Fay398
            ]
        }
    }
}
