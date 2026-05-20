//
//  GradeDecompositionDTO.swift
//  ProccessesMobile
//

import Foundation

struct GradeDecompositionResponseDTO: Equatable, Sendable, Codable {
    let postId: String?
    let solutionId: String?
    let maxGrade: Double?
    let basicScore: Double?
    let modifierEffects: [ModifierEffectDTO]
    let finalScore: Double?
    let criteriaBreakdown: [CriterionGradeResultItemDTO]
    let publishedAt: String?
}
