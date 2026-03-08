//
//  SolutionValidationError.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 07.03.2026.
//

enum SolutionValidationErrorDTO: Error, Equatable, Sendable {
    case invalidTextLength(max: Int)
    case emptyCourseId
    case emptyPostId
    case emptySolutionId
}
