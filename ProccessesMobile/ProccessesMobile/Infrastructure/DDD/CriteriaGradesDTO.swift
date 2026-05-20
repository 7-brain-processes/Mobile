//
//  CriteriaGradesDTO.swift
//  ProccessesMobile
//

import Foundation

struct CriteriaGradeRequestDTO: Equatable, Sendable, Codable {
    let grades: [CriterionGradeEntryDTO]
}

struct CriterionGradeEntryDTO: Equatable, Sendable, Codable {
    let criterionId: String
    let value: Double
    let comment: String?
}

struct CriteriaGradeResponseDTO: Equatable, Sendable, Codable {
    let solutionId: String
    let criteriaGrades: [CriterionGradeResultItemDTO]
    let modifierEffects: [ModifierEffectDTO]
    let basicScore: Double?
    let modifierDelta: Double?
    let finalScore: Double?
    let maxGrade: Double?
    let isPublished: Bool
    let gradedAt: String?
}

struct CriterionGradeResultItemDTO: Equatable, Sendable, Codable {
    let criterion: CriterionConfigDTO
    let value: Double
    let computedPoints: Double?
    let comment: String?
}

struct ModifierEffectDTO: Equatable, Sendable, Codable {
    let modifierType: String
    let description: String?
    let delta: Double?
}
