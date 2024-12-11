//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsR4


extension Resource: @retroactive Identifiable {
    public typealias ID = FHIRPrimitive<FHIRString>?
}


extension FHIRPrimitive: @retroactive Identifiable where PrimitiveType: Identifiable { }
