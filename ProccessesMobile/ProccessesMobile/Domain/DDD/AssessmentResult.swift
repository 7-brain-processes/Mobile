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
    let modifierDelta: Double?
    let finalScore: Double?
    let maxGrade: Double?
    let published: Bool

    init(
        solutionId: UUID,
        criteriaGrades: [CriterionGrade],
        modifierEffects: [ModifierEffect] = [],
        basicScore: Double? = nil,
        modifierDelta: Double? = nil,
        finalScore: Double? = nil,
        maxGrade: Double? = nil,
        published: Bool
    ) {
        self.solutionId = solutionId
        self.criteriaGrades = criteriaGrades
        self.modifierEffects = modifierEffects
        self.basicScore = basicScore
        self.modifierDelta = modifierDelta
        self.finalScore = finalScore
        self.maxGrade = maxGrade
        self.published = published
    }
}
