//
//  CriteriaGradesDTO.swift
//  ProccessesMobile
//

import Foundation

struct CriteriaGradeRequestDTO: Equatable, Sendable, Codable {
    let criteria: [CriterionGradeEntryDTO]
}

struct CriterionGradeEntryDTO: Equatable, Sendable, Codable {
    let criterionId: String
    let value: Double
    let comment: String?
}

struct CriteriaGradeResponseDTO: Equatable, Sendable, Codable {
    let solutionId: String
    let criteriaGrades: [CriterionGradeEntryDTO]
    let modifierEffects: [ModifierEffectDTO]
    let basicScore: Double?
    let finalScore: Double?
    let published: Bool
}

struct ModifierEffectDTO: Equatable, Sendable, Codable {
    let type: String
    let value: Double?
    let description: String?
}
