//
//  AssessmentModifier.swift
//  ProccessesMobile
//

import Foundation

struct AssessmentModifier: Equatable, Sendable {
    let id: UUID?

    init(id: UUID? = nil) {
        self.id = id
    }
}
