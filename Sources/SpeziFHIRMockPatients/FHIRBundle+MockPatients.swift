//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
@preconcurrency import class ModelsR4.Bundle
import SpeziFoundation


/// Fetches and stores mock patients in a structured Concurrency-safe way
actor MockR4Bundles {
    fileprivate static let shared = MockR4Bundles()
    
    nonisolated(unsafe) private var _jamison785Denesik803: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Jamison785 Denesik803.
    var jamison785Denesik803: ModelsR4.Bundle {
        if let jamison785Denesik803 = _jamison785Denesik803 {
            return jamison785Denesik803
        }
        
        let jamison785Denesik803 = Foundation.Bundle.module.loadFHIRBundle(
            withName: "Jamison785_Denesik803_1e08cb3f-9e6a-b083-b6ee-0bb38f70ba50"
        )
        _jamison785Denesik803 = jamison785Denesik803
        return jamison785Denesik803
    }
    
    nonisolated(unsafe) private var _maye976Dickinson688: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Maye976 Dickinson688.
    var maye976Dickinson688: ModelsR4.Bundle {
        if let maye976Dickinson688 = _maye976Dickinson688 {
            return maye976Dickinson688
        }
        
        let maye976Dickinson688 = Foundation.Bundle.module.loadFHIRBundle(
            withName: "Maye976_Dickinson688_04f25f73-04b2-469c-3806-540417a0d61c"
        )
        _maye976Dickinson688 = maye976Dickinson688
        return maye976Dickinson688
    }

    nonisolated(unsafe) private var _milagros256Hills818: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Milagros256 Hills818.
    var milagros256Hills818: ModelsR4.Bundle {
        if let milagros256Hills818 = _milagros256Hills818 {
            return milagros256Hills818
        }
        
        let milagros256Hills818 = Foundation.Bundle.module.loadFHIRBundle(
            withName: "Milagros256_Hills818_79b1d90a-0eaf-be78-9bbf-91c638626012"
        )
        _milagros256Hills818 = milagros256Hills818
        return milagros256Hills818
    }
    
    nonisolated(unsafe) private var _napoleon578Fay398: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Napoleon578 Fay398.
    var napoleon578Fay398: ModelsR4.Bundle {
        if let napoleon578Fay398 = _napoleon578Fay398 {
            return napoleon578Fay398
        }
        
        let napoleon578Fay398 = Foundation.Bundle.module.loadFHIRBundle(
            withName: "Napoleon578_Fay398_38f38890-b80f-6542-51d4-882c7b37b0bf"
        )
        _napoleon578Fay398 = napoleon578Fay398
        return napoleon578Fay398
    }
    
    nonisolated(unsafe) private var _allen322Ferry570: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Allen322 Ferry570.
    var allen322Ferry570: ModelsR4.Bundle {
        if let allen322Ferry570 = _allen322Ferry570 {
            return allen322Ferry570
        }
        
        let allen322Ferry570 = Foundation.Bundle.main.loadFHIRBundle(
            withName: "Allen322_Ferry570_ad134528-56a5-35fd-c37f-466ff119c625"
        )
        _allen322Ferry570 = allen322Ferry570
        return allen322Ferry570
    }
    
    nonisolated(unsafe) private var _beatris270Bogan287: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Beatris270 Bogan287.
    var beatris270Bogan287: ModelsR4.Bundle {
        if let beatris270Bogan287 = _beatris270Bogan287 {
            return beatris270Bogan287
        }
        
        let beatris270Bogan287 = Foundation.Bundle.main.loadFHIRBundle(
            withName: "Beatris270_Bogan287_5b3645de-a2d0-d016-0839-bab3757c4c58"
        )
        _beatris270Bogan287 = beatris270Bogan287
        return beatris270Bogan287
    }
    
    nonisolated(unsafe) private var _edythe31Morar593: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Edythe31 Morar593.
    var edythe31Morar593: ModelsR4.Bundle {
        if let edythe31Morar593 = _edythe31Morar593 {
            return edythe31Morar593
        }
        
        let edythe31Morar593 = Foundation.Bundle.main.loadFHIRBundle(
            withName: "Edythe31_Morar593_9c3df38a-d3b7-2198-3898-51f9153d023d"
        )
        _edythe31Morar593 = edythe31Morar593
        return edythe31Morar593
    }
    
    nonisolated(unsafe) private var _gonzalo160Duenas839: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Gonzalo160 Duenas839.
    var gonzalo160Duenas839: ModelsR4.Bundle {
        if let gonzalo160Duenas839 = _gonzalo160Duenas839 {
            return gonzalo160Duenas839
        }
        
        let gonzalo160Duenas839 = Foundation.Bundle.main.loadFHIRBundle(
            withName: "Gonzalo160_Duenas839_ed70a28f-30b2-acb7-658a-8b340dadd685"
        )
        _gonzalo160Duenas839 = gonzalo160Duenas839
        return gonzalo160Duenas839
    }
    
    nonisolated(unsafe) private var _jacklyn830Veum823: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Jacklyn830 Veum823.
    var jacklyn830Veum823: ModelsR4.Bundle {
        if let jacklyn830Veum823 = _jacklyn830Veum823 {
            return jacklyn830Veum823
        }
        
        let jacklyn830Veum823 = Foundation.Bundle.main.loadFHIRBundle(
            withName: "Jacklyn830_Veum823_e0e1f21a-22a7-d166-7bb1-63f6bbce1a32"
        )
        _jacklyn830Veum823 = jacklyn830Veum823
        return jacklyn830Veum823
    }
    
    nonisolated(unsafe) private var _milton509Ortiz186: ModelsR4.Bundle?
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Milton509 Ortiz186.
    var milton509Ortiz186: ModelsR4.Bundle {
        if let milton509Ortiz186 = _milton509Ortiz186 {
            return milton509Ortiz186
        }
        
        let milton509Ortiz186 = Foundation.Bundle.main.loadFHIRBundle(
            withName: "Milton509_Ortiz186_d66b5418-06cb-fc8a-8c13-85685b6ac939"
        )
        _milton509Ortiz186 = milton509Ortiz186
        return milton509Ortiz186
    }
}


extension ModelsR4.Bundle {
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Jamison785 Denesik803.
    public static var jamison785Denesik803: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.shared.jamison785Denesik803
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Maye976 Dickinson688.
    public static var maye976Dickinson688: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.shared.maye976Dickinson688
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Milagros256 Hills818.
    public static var milagros256Hills818: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.shared.milagros256Hills818
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Napoleon578 Fay398.
    public static var napoleon578Fay398: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.shared.napoleon578Fay398
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Allen322 Ferry570.
    public static var allen322Ferry570: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.shared.allen322Ferry570
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Beatris270 Bogan287.
    public static var beatris270Bogan287: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.shared.beatris270Bogan287
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Edythe31 Morar593.
    public static var edythe31Morar593: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.shared.edythe31Morar593
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Gonzalo160 Duenas839.
    public static var gonzalo160Duenas839: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.shared.gonzalo160Duenas839
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Jacklyn830 Veum823.
    public static var jacklyn830Veum823: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.shared.jacklyn830Veum823
        }
    }
    
    /// Example FHIR resources packed into a bundle to represent the simulated patient named Milton509 Ortiz186.
    public static var milton509Ortiz186: ModelsR4.Bundle {
        get async {
            await MockR4Bundles.shared.milton509Ortiz186
        }
    }
    
    
    /// Loads a select group of example FHIR resources packed into a bundle to represent the simulated patients.
    public static var mockPatients: [Bundle] {
        get async {
            await [
                .jamison785Denesik803,
                .maye976Dickinson688,
                .milagros256Hills818,
                .napoleon578Fay398,
                .allen322Ferry570,
                .beatris270Bogan287,
                .edythe31Morar593,
                .gonzalo160Duenas839,
                .jacklyn830Veum823,
                .milton509Ortiz186
            ]
        }
    }
}
