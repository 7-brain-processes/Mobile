//
//  AssessmentResult.swift
//  ProccessesMobile
//

import Foundation

struct AssessmentResult: Equatable, Sendable {
    let solutionId: UUID
    let criteriaGrades: [CriterionGrade]
    let modifierEffects: [ModifierEffect]
    let basicScore: Double?
    let finalScore: Double?
    let published: Bool

    init(
        solutionId: UUID,
        criteriaGrades: [CriterionGrade],
        modifierEffects: [ModifierEffect] = [],
        basicScore: Double? = nil,
        finalScore: Double? = nil,
        published: Bool
    ) {
        self.solutionId = solutionId
        self.criteriaGrades = criteriaGrades
        self.modifierEffects = modifierEffects
        self.basicScore = basicScore
        self.finalScore = finalScore
        self.published = published
    }
}
