//
//  MockUploadSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockUploadSolutionFileUseCase: UploadSolutionFileUseCase {
    private let repository: SolutionFilesRepository
    init(repository: SolutionFilesRepository) { self.repository = repository }
    
    func execute(courseId: String, postId: String, solutionId: String, request: UploadFileRequest) async throws -> AttachedFile {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("courseId") }
        guard !solutionId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("solutionId") }
        guard !request.data.isEmpty else { throw FileValidationError.emptyFileData }
        
        return try await repository.uploadSolutionFile(courseId: courseId, postId: postId, solutionId: solutionId, request: request)
    }
}
