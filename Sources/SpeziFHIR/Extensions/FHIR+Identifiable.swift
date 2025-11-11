//
// This source file is part of the Stanford Spezi open source project
//
// SPDX-FileCopyrightText: 2023 Stanford University and the project authors (see CONTRIBUTORS.md)
//
// SPDX-License-Identifier: MIT
//

import ModelsDSTU2
import ModelsR4


extension ModelsDSTU2.Resource: @retroactive Identifiable {
    public typealias ID = ModelsDSTU2.FHIRPrimitive<ModelsDSTU2.FHIRString>?
}


extension ModelsR4.Resource: @retroactive Identifiable {
    public typealias ID = ModelsR4.FHIRPrimitive<ModelsR4.FHIRString>?
}
