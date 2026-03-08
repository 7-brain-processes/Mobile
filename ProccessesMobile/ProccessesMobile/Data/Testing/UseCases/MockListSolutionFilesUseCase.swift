//
//  MockListSolutionFilesUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Foundation

struct MockListSolutionFilesUseCase: ListSolutionFilesUseCase {
    let repo: SolutionFilesRepository
    func execute(courseId: String, postId: String, solutionId: String) async throws -> [AttachedFile] {
        guard !solutionId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("solutionId") }
        return try await repo.listSolutionFiles(courseId: courseId, postId: postId, solutionId: solutionId)
    }
}
