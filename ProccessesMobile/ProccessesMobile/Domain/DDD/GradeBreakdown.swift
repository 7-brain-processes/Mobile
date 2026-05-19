//
//  GradeBreakdown.swift
//  ProccessesMobile
//

import Foundation

struct GradeBreakdown: Equatable, Sendable {
    let basicScore: Double?
    let modifierDelta: Double?
    let finalScore: Double?
    let criteria: [CriterionBreakdownItem]
    let modifiers: [ModifierBreakdownItem]

    init(
        basicScore: Double? = nil,
        modifierDelta: Double? = nil,
        finalScore: Double? = nil,
        criteria: [CriterionBreakdownItem],
        modifiers: [ModifierBreakdownItem] = []
    ) {
        self.basicScore = basicScore
        self.modifierDelta = modifierDelta
        self.finalScore = finalScore
        self.criteria = criteria
        self.modifiers = modifiers
    }
}

struct CriterionBreakdownItem: Equatable, Sendable {
    let criterionId: UUID?
    let title: String
    let type: CriterionType
    let value: Double?
    let score: Double?
    let comment: String?

    init(
        criterionId: UUID? = nil,
        title: String,
        type: CriterionType,
        value: Double? = nil,
        score: Double? = nil,
        comment: String? = nil
    ) {
        self.criterionId = criterionId
        self.title = title
        self.type = type
        self.value = value
        self.score = score
        self.comment = comment
    }
}

struct ModifierBreakdownItem: Equatable, Sendable {
    let modifierId: UUID?
    let title: String
    let value: Double?
    let effect: Double?
    let description: String?

    init(
        modifierId: UUID? = nil,
        title: String,
        value: Double? = nil,
        effect: Double? = nil,
        description: String? = nil
    ) {
        self.modifierId = modifierId
        self.title = title
        self.value = value
        self.effect = effect
        self.description = description
    }
}
