//
//  UploadPostMaterialUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol UploadPostMaterialUseCase: Sendable {
    func execute(courseId: String, postId: String, request: UploadFileRequest) async throws -> AttachedFile
}