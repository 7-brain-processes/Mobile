//
//  CriterionGrade.swift
//  ProccessesMobile
//

import Foundation

struct CriterionGrade: Equatable, Sendable {
    let criterionId: UUID
    let value: Double
    let comment: String?

    init(
        criterionId: UUID,
        value: Double,
        comment: String? = nil
    ) {
        self.criterionId = criterionId
        self.value = value
        self.comment = comment
    }
}
