//
//  GetCriteriaGradesQuery.swift
//  ProccessesMobile
//

import Foundation

struct GetCriteriaGradesQuery: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
}
