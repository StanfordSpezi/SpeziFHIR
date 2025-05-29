//
// This source file is part of the Stanford Spezi open-source project
//
// SPDX-FileCopyrightText: 2025 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import Foundation
import ModelsDSTU2
import ModelsR4
@testable import SpeziFHIR
import Testing


@Suite("FHIRResource Copy Tests")
struct FHIRResourceCopyTests {
    @Test("FHIRResource - Copy Complex R4 Resource")
    func testCopyComplexR4Resource() throws {
        let r4DocumentReference = try ModelsR4Mocks.createMixedDocumentReference()
        let r4Resource = FHIRResource(resource: r4DocumentReference, displayName: "Complex R4 Document")

        let copiedR4Resource = try r4Resource.copy()

        #expect(r4Resource.displayName == copiedR4Resource.displayName, "DisplayName was not copied correctly")

        let originalDoc: ModelsR4.DocumentReference? = if case let (.r4(res)) = r4Resource.versionedResource {
            res as? ModelsR4.DocumentReference
        } else {
            nil
        }

        let copiedDoc: ModelsR4.DocumentReference? = if case let (.r4(res)) = copiedR4Resource.versionedResource {
            res as? ModelsR4.DocumentReference
        } else {
            nil
        }

        #expect(originalDoc?.id?.value?.string == copiedDoc?.id?.value?.string, "ID was not copied correctly")

        #expect(originalDoc?.content.count == 2, "Original should have 2 attachments")
        #expect(copiedDoc?.content.count == 2, "Copy should have 2 attachments")

        if let mutableCopy = copiedDoc, let originalAttachment = originalDoc?.content.first?.attachment {
            if var title = mutableCopy.content.first?.attachment.title {
                title.value = ModelsR4.FHIRString("Modified Title")
            }

            #expect(originalAttachment.title?.value?.string != "Modified Title", "Modifying copy should not affect original")
        }
    }

    @Test("FHIRResource - Copy Concurrency")
    func testCopyConcurrency() throws {
        let resources: [FHIRResource] = [
            FHIRResource(resource: try ModelsR4Mocks.createPatient(), displayName: "Patient"),
            FHIRResource(resource: try ModelsR4Mocks.createCondition(), displayName: "Condition"),
            FHIRResource(resource: try ModelsR4Mocks.createObservation(), displayName: "Observation"),
            FHIRResource(resource: try ModelsR4Mocks.createDocumentReference(), displayName: "DocumentReference"),
            FHIRResource(resource: try ModelsR4Mocks.createImmunization(), displayName: "Immunization"),
            FHIRResource(resource: ModelsDSTU2Mocks.createAllergyIntolerance(), displayName: "AllergyIntolerance"),
            FHIRResource(resource: ModelsDSTU2Mocks.createDiagnosticOrder(), displayName: "DiagnosticOrder"),
            FHIRResource(resource: try ModelsDSTU2Mocks.createDiagnosticReport(), displayName: "DiagnosticReport"),
            FHIRResource(resource: try ModelsDSTU2Mocks.createObservation(), displayName: "Observation"),
            FHIRResource(resource: ModelsDSTU2Mocks.createImmunization(), displayName: "Immunization")
        ]

        let group = DispatchGroup()
        let queue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)

        let lock = NSLock()

        var copiedResourcesDict = [Int: FHIRResource]()

        for (index, resource) in resources.enumerated() {
            group.enter()
            queue.async {
                defer {
                    group.leave()
                }
                do {
                    let copiedResource = try resource.copy()
                    lock.withLock {
                        copiedResourcesDict[index] = copiedResource
                    }
                } catch {
                    Issue.record("Failed to copy resource \(resource.displayName): \(error)")
                }
            }
        }

        let timeoutResult = group.wait(timeout: .now() + 7.5)
        #expect(timeoutResult == .success, "Copy operations timed out")

        for (index, original) in resources.enumerated() {
            if let copy = copiedResourcesDict[index] {
                #expect(original.displayName == copy.displayName, "Copy at index \(index) has incorrect displayName: expected \(original.displayName), got \(copy.displayName)")
            } else {
                Issue.record("Missing copied resource at index \(index)")
            }
        }
    }
}
