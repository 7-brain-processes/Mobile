//
//  AssessmentModifier.swift
//  ProccessesMobile
//

import Foundation

struct AssessmentModifier: Equatable, Sendable {
    let id: UUID?
    let type: ModifierType
    let enabled: Bool

    init(
        id: UUID? = nil,
        type: ModifierType,
        enabled: Bool
    ) {
        self.id = id
        self.type = type
        self.enabled = enabled
    }
}
