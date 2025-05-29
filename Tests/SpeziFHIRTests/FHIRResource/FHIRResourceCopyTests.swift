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
    func testCopyConcurrency() async throws {
        struct UnsafelySendableFHIRResource: @unchecked Sendable {
            let resource: FHIRResource
        }
        
        final class CopiedResources: @unchecked Sendable {
            private let lock = NSLock()
            private(set) var resources: [Int: UnsafelySendableFHIRResource] = [:]
            
            func add(_ resource: FHIRResource, at index: Int) {
                lock.withLock {
                    resources[index] = .init(resource: resource)
                }
            }
        }
        
        let resources: [UnsafelySendableFHIRResource] = [
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
        ].map { .init(resource: $0) }
        
        if false {
//            let group = DispatchGroup()
//            let queue = DispatchQueue(label: "com.test.concurrent", attributes: .concurrent)
//            let copiedResources = CopiedResources()
//            
//            for (index, resource) in resources.enumerated() {
//                group.enter()
//                queue.async {
//                    defer {
//                        group.leave()
//                    }
//                    do {
//                        let copiedResource = try resource.resource.copy()
//                        copiedResources.add(copiedResource, at: index)
//                    } catch {
//                        Issue.record("Failed to copy resource \(resource.resource.displayName): \(error)")
//                    }
//                }
//            }
//            
//            let timeoutResult = group.wait(timeout: .now() + 10)
//            #expect(timeoutResult == .success, "Copy operations timed out")
//            
//            for (index, original) in resources.enumerated() {
//                if let copy = copiedResources.resources[index] {
//                    let original = original.resource
//                    let copy = copy.resource
//                    #expect(original.displayName == copy.displayName, "Copy at index \(index) has incorrect displayName: expected \(original.displayName), got \(copy.displayName)")
//                } else {
//                    Issue.record("Missing copied resource at index \(index)")
//                }
//            }
        } else {
            let copiedResources = try await withThrowingTaskGroup(of: UnsafelySendableFHIRResource.self) { taskGroup in
                // copy every resource 20 times, and hope that at least some of them end up happening in parallel.
                for _ in 0..<20 {
                    for resource in resources {
                        taskGroup.addTask {
                            UnsafelySendableFHIRResource(resource: try resource.resource.copy())
                        }
                    }
                }
                var results: [UnsafelySendableFHIRResource] = []
                for try await resource in taskGroup {
                    results.append(resource)
                }
                return results
            }
            for original in resources {
                print(original.resource.id)
                let copies = copiedResources.filter { copy in
                    copy.resource.displayName == original.resource.displayName && copy.resource.variantDesc == original.resource.variantDesc
                }
                #expect(copies.count == 20, "Copying of '\(original.resource.displayName)' failed.")
            }
        }
    }
}



extension FHIRResource {
    var variantDesc: String {
        switch versionedResource {
        case .r4: "r4"
        case .dstu2: "dstu2"
        }
    }
}
