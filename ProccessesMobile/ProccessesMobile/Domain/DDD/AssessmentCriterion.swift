//
//  AssessmentCriterion.swift
//  ProccessesMobile
//

import Foundation

struct AssessmentCriterion: Equatable, Sendable {
    let id: UUID?
    let title: String
    let type: CriterionType
    let maxPoints: Double
    let weight: Double
    let commentEnabled: Bool

    init(
        id: UUID? = nil,
        title: String,
        type: CriterionType,
        maxPoints: Double,
        weight: Double,
        commentEnabled: Bool = false
    ) {
        self.id = id
        self.title = title
        self.type = type
        self.maxPoints = maxPoints
        self.weight = weight
        self.commentEnabled = commentEnabled
    }
}
