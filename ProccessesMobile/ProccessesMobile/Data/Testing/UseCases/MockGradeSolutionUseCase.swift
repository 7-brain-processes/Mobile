//
//  MockGradeSolutionUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockGradeSolutionUseCase: GradeSolutionUseCase {
    private let repository: GradingRepository
    init(repository: GradingRepository) { self.repository = repository }
    
    func execute(courseId: String, postId: String, solutionId: String, request: GradeRequest) async throws -> Solution {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw InteractionValidationError.emptyId("courseId") }
        guard !postId.trimmingCharacters(in: .whitespaces).isEmpty else { throw InteractionValidationError.emptyId("postId") }
        guard !solutionId.trimmingCharacters(in: .whitespaces).isEmpty else { throw InteractionValidationError.emptyId("solutionId") }

        guard request.grade >= 0 && request.grade <= 100 else {
            throw InteractionValidationError.invalidGrade(min: 0, max: 100)
        }
        
        // Validate optional feedback comment
        if let comment = request.comment, comment.count > 5000 {
            throw InteractionValidationError.invalidCommentLength(min: 0, max: 5000)
        }
        
        return try await repository.gradeSolution(courseId: courseId, postId: postId, solutionId: solutionId, request: request)
    }
}
