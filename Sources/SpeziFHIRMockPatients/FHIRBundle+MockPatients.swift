//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import class ModelsR4.Bundle


/// Fetches and stores mock patients in a structured Concurrency-safe way
actor MockR4Bundles {
    private static var _jamison785Denesik803: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Jamison785 Denesik803.
    static var jamison785Denesik803: ModelsR4.Bundle {
        get async {
            if let jamison785Denesik803 = _jamison785Denesik803 {
                return jamison785Denesik803
            }
            
            let jamison785Denesik803 = await Foundation.Bundle.module.loadFHIRBundle(
                withName: "Jamison785_Denesik803_1e08cb3f-9e6a-b083-b6ee-0bb38f70ba50"
            )
            Self._jamison785Denesik803 = jamison785Denesik803
            return jamison785Denesik803
        }
    }
    
    private static var _maye976Dickinson688: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Maye976 Dickinson688.
    static var maye976Dickinson688: ModelsR4.Bundle {
        get async {
            if let maye976Dickinson688 = _maye976Dickinson688 {
                return maye976Dickinson688
            }
            
            let maye976Dickinson688 = await Foundation.Bundle.module.loadFHIRBundle(
                withName: "Maye976_Dickinson688_04f25f73-04b2-469c-3806-540417a0d61c"
            )
            Self._maye976Dickinson688 = maye976Dickinson688
            return maye976Dickinson688
        }
    }
    
    private static var _milagros256Hills818: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Milagros256 Hills818.
    static var milagros256Hills818: ModelsR4.Bundle {
        get async {
            if let milagros256Hills818 = _milagros256Hills818 {
                return milagros256Hills818
            }
            
            let milagros256Hills818 = await Foundation.Bundle.module.loadFHIRBundle(
                withName: "Milagros256_Hills818_79b1d90a-0eaf-be78-9bbf-91c638626012"
            )
            Self._milagros256Hills818 = milagros256Hills818
            return milagros256Hills818
        }
    }
    
    private static var _napoleon578Fay398: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Napoleon578 Fay398.
    static var napoleon578Fay398: ModelsR4.Bundle {
        get async {
            if let napoleon578Fay398 = _napoleon578Fay398 {
                return napoleon578Fay398
            }
            
            let napoleon578Fay398 = await Foundation.Bundle.module.loadFHIRBundle(
                withName: "Napoleon578_Fay398_38f38890-b80f-6542-51d4-882c7b37b0bf"
            )
            Self._napoleon578Fay398 = napoleon578Fay398
            return napoleon578Fay398
        }
    }
    
    private static var _allen322Ferry570: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Allen322 Ferry570.
    static var allen322Ferry570: ModelsR4.Bundle {
        get async {
            if let allen322Ferry570 = _allen322Ferry570 {
                return allen322Ferry570
            }
            
            let allen322Ferry570 = await Foundation.Bundle.main.loadFHIRBundle(
                withName: "Allen322_Ferry570_ad134528-56a5-35fd-c37f-466ff119c625"
            )
            self._allen322Ferry570 = allen322Ferry570
            return allen322Ferry570
        }
    }
    
    private static var _beatris270Bogan287: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Beatris270 Bogan287.
    static var beatris270Bogan287: ModelsR4.Bundle {
        get async {
            if let beatris270Bogan287 = _beatris270Bogan287 {
                return beatris270Bogan287
            }
            
            let beatris270Bogan287 = await Foundation.Bundle.main.loadFHIRBundle(
                withName: "Beatris270_Bogan287_5b3645de-a2d0-d016-0839-bab3757c4c58"
            )
            Self._beatris270Bogan287 = beatris270Bogan287
            return beatris270Bogan287
        }
    }
    
    private static var _edythe31Morar593: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Edythe31 Morar593.
    static var edythe31Morar593: ModelsR4.Bundle {
        get async {
            if let edythe31Morar593 = _edythe31Morar593 {
                return edythe31Morar593
            }
            
            let edythe31Morar593 = await Foundation.Bundle.main.loadFHIRBundle(
                withName: "Edythe31_Morar593_9c3df38a-d3b7-2198-3898-51f9153d023d"
            )
            Self._edythe31Morar593 = edythe31Morar593
            return edythe31Morar593
        }
    }
    
    private static var _gonzalo160Duenas839: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Gonzalo160 Duenas839.
    static var gonzalo160Duenas839: ModelsR4.Bundle {
        get async {
            if let gonzalo160Duenas839 = _gonzalo160Duenas839 {
                return gonzalo160Duenas839
            }
            
            let gonzalo160Duenas839 = await Foundation.Bundle.main.loadFHIRBundle(
                withName: "Gonzalo160_Duenas839_ed70a28f-30b2-acb7-658a-8b340dadd685"
            )
            Self._gonzalo160Duenas839 = gonzalo160Duenas839
            return gonzalo160Duenas839
        }
    }
    
    private static var _jacklyn830Veum823: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Jacklyn830 Veum823.
    static var jacklyn830Veum823: ModelsR4.Bundle {
        get async {
            if let jacklyn830Veum823 = _jacklyn830Veum823 {
                return jacklyn830Veum823
            }
            
            let jacklyn830Veum823 = await Foundation.Bundle.main.loadFHIRBundle(
                withName: "Jacklyn830_Veum823_e0e1f21a-22a7-d166-7bb1-63f6bbce1a32"
            )
            Self._jacklyn830Veum823 = jacklyn830Veum823
            return jacklyn830Veum823
        }
    }
    
    private static var _milton509Ortiz186: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Milton509 Ortiz186.
    static var milton509Ortiz186: ModelsR4.Bundle {
        get async {
            if let milton509Ortiz186 = _milton509Ortiz186 {
                return milton509Ortiz186
            }
            
            let milton509Ortiz186 = await Foundation.Bundle.main.loadFHIRBundle(
                withName: "Milton509_Ortiz186_d66b5418-06cb-fc8a-8c13-85685b6ac939"
            )
            Self._milton509Ortiz186 = milton509Ortiz186
            return milton509Ortiz186
        }
    }
}


extension ModelsR4.Bundle {
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Jamison785 Denesik803.
    public static var jamison785Denesik803: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.jamison785Denesik803
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Maye976 Dickinson688.
    public static var maye976Dickinson688: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.maye976Dickinson688
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Milagros256 Hills818.
    public static var milagros256Hills818: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.milagros256Hills818
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Napoleon578 Fay398.
    public static var napoleon578Fay398: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.napoleon578Fay398
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Allen322 Ferry570.
    public static var allen322Ferry570: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.allen322Ferry570
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Beatris270 Bogan287.
    public static var beatris270Bogan287: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.beatris270Bogan287
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Edythe31 Morar593.
    public static var edythe31Morar593: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.edythe31Morar593
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Gonzalo160 Duenas839.
    public static var gonzalo160Duenas839: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.gonzalo160Duenas839
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Jacklyn830 Veum823.
    public static var jacklyn830Veum823: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.jacklyn830Veum823
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Milton509 Ortiz186.
    public static var milton509Ortiz186: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.milton509Ortiz186
        }
    }
    
    
    /// Loads a select group of example FHIR resources packed into a bundle to represent the simulated patients.
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
