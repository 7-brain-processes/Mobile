//
//  UpdateCriteriaGradesCommand.swift
//  ProccessesMobile
//

import Foundation

struct UpdateCriteriaGradesCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
    let grades: [CriterionGrade]
}
