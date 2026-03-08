//
//  MockDeleteSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockDeleteSolutionFileUseCase: DeleteSolutionFileUseCase {
    let repo: SolutionFilesRepository
    func execute(courseId: String, postId: String, solutionId: String, fileId: String) async throws {
        guard !fileId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("fileId") }
        try await repo.deleteSolutionFile(courseId: courseId, postId: postId, solutionId: solutionId, fileId: fileId)
    }
}
