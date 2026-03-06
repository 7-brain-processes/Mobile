//
//  MockListPostMaterialsUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockListPostMaterialsUseCase: ListPostMaterialsUseCase {
    let repo: PostMaterialsRepository
    public func execute(courseId: String, postId: String) async throws -> [AttachedFile] {
        guard !courseId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("courseId") }
        guard !postId.trimmingCharacters(in: .whitespaces).isEmpty else { throw FileValidationError.emptyId("postId") }
        return try await repo.listMaterials(courseId: courseId, postId: postId)
    }
}
