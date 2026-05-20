//
//  GradeDecompositionDTO.swift
//  ProccessesMobile
//

import Foundation

struct GradeDecompositionResponseDTO: Equatable, Sendable, Codable {
    let basicScore: Double?
    let modifierDelta: Double?
    let finalScore: Double?
    let criteria: [CriterionBreakdownDTO]
    let modifiers: [ModifierBreakdownDTO]
}

struct CriterionBreakdownDTO: Equatable, Sendable, Codable {
    let criterionId: String?
    let title: String
    let type: String
    let value: Double?
    let score: Double?
    let comment: String?
}

struct ModifierBreakdownDTO: Equatable, Sendable, Codable {
    let type: String
    let title: String?
    let delta: Double?
    let description: String?
}
