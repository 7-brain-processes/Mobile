//
//  AssessmentConfig.swift
//  ProccessesMobile
//

import Foundation

struct AssessmentConfig: Equatable, Sendable {
    let id: UUID?
    let maxGrade: Double
    let criteria: [AssessmentCriterion]
    let modifiers: [AssessmentModifier]
    let resultsVisible: Bool

    init(
        id: UUID? = nil,
        maxGrade: Double,
        criteria: [AssessmentCriterion],
        modifiers: [AssessmentModifier] = [],
        resultsVisible: Bool
    ) {
        self.id = id
        self.maxGrade = maxGrade
        self.criteria = criteria
        self.modifiers = modifiers
        self.resultsVisible = resultsVisible
    }
}
