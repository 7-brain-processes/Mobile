//
//  UploadSolutionFileUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol UploadSolutionFileUseCase: Sendable {
    func execute(courseId: String, postId: String, solutionId: String, request: UploadFileRequest) async throws -> AttachedFile
}