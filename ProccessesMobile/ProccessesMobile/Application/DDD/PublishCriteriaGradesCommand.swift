//
//  PublishCriteriaGradesCommand.swift
//  ProccessesMobile
//

import Foundation

struct PublishCriteriaGradesCommand: Equatable, Sendable {
    let courseId: UUID
    let postId: UUID
    let solutionId: UUID
}
