//
//  ModifierEffect.swift
//  ProccessesMobile
//

import Foundation

struct ModifierEffect: Equatable, Sendable {
    let type: ModifierType
    let value: Double?
    let description: String?

    init(
        type: ModifierType,
        value: Double? = nil,
        description: String? = nil
    ) {
        self.type = type
        self.value = value
        self.description = description
    }
}
