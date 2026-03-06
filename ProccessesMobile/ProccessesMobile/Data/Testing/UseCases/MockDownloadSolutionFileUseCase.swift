//
//  MockDownloadSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockDownloadSolutionFileUseCase: DownloadSolutionFileUseCase {
    let repo: SolutionFilesRepository
    public func execute(courseId: String, postId: String, solutionId: String, fileId: String) async throws -> Data {
        guard !fileId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("fileId") }
        return try await repo.downloadSolutionFile(courseId: courseId, postId: postId, solutionId: solutionId, fileId: fileId)
    }
}
