//
//  MockDeletePostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockDeletePostMaterialUseCase: DeletePostMaterialUseCase {
    let repo: PostMaterialsRepository
    public func execute(courseId: String, postId: String, fileId: String) async throws {
        guard !fileId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("fileId") }
        try await repo.deleteMaterial(courseId: courseId, postId: postId, fileId: fileId)
    }
}
