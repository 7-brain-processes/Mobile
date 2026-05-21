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
    let config: AssessmentConfig?

    init(
        courseId: UUID,
        postId: UUID,
        solutionId: UUID,
        grades: [CriterionGrade],
        config: AssessmentConfig? = nil
    ) {
        self.courseId = courseId
        self.postId = postId
        self.solutionId = solutionId
        self.grades = grades
        self.config = config
    }
}
