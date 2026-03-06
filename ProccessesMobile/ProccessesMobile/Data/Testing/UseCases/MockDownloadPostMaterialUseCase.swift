//
//  MockDownloadPostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockDownloadPostMaterialUseCase: DownloadPostMaterialUseCase {
    let repo: PostMaterialsRepository
    public func execute(courseId: String, postId: String, fileId: String) async throws -> Data {
        guard !fileId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("fileId") }
        return try await repo.downloadMaterial(courseId: courseId, postId: postId, fileId: fileId)
    }
}
