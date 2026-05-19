//
//  ModifierEffect.swift
//  ProccessesMobile
//

import Foundation

struct ModifierEffect: Equatable, Sendable {
    let modifierId: UUID?
    let value: Double
    let description: String?

    init(
        modifierId: UUID? = nil,
        value: Double,
        description: String? = nil
    ) {
        self.modifierId = modifierId
        self.value = value
        self.description = description
    }
}
