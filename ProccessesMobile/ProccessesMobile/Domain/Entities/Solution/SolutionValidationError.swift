//
//  SolutionValidationError.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum SolutionValidationError: Error, Equatable, Sendable {
    case invalidTextLength(max: Int)
    case emptyCourseId
    case emptyPostId
    case emptySolutionId
}
