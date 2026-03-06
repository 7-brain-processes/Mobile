//
//  MockUploadPostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockUploadPostMaterialUseCase: UploadPostMaterialUseCase {
    private let repository: PostMaterialsRepository
    public init(repository: PostMaterialsRepository) { self.repository = repository }
    
    public func execute(courseId: String, postId: String, request: UploadFileRequest) async throws -> AttachedFile {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("courseId") }
        guard !postId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("postId") }
        guard !request.fileName.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.invalidFileName }
        guard !request.data.isEmpty else { throw FileValidationError.emptyFileData }
        
        return try await repository.uploadMaterial(courseId: courseId, postId: postId, request: request)
    }
}
