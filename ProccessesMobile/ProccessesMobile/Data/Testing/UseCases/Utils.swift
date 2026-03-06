//
//  File.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

internal func validateIds(courseId: String, postId: String, solutionId: String? = nil) throws {
    guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw SolutionValidationError.emptyCourseId }
    guard !postId.trimmingCharacters(in: .whitespaces).isEmpty else { throw SolutionValidationError.emptyPostId }
    if let sid = solutionId {
        guard !sid.trimmingCharacters(in: .whitespaces).isEmpty else { throw SolutionValidationError.emptySolutionId }
    }
}

internal func validateAndSanitize(request: CreateSolutionRequest) throws -> CreateSolutionRequest {
    if let text = request.text, text.count > 10000 {
        throw SolutionValidationError.invalidTextLength(max: 10000)
    }
    return CreateSolutionRequest(text: request.text?.trimmingCharacters(in: .whitespacesAndNewlines))
}
