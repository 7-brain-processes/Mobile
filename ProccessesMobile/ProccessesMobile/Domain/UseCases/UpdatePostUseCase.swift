//
//  UpdatePostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol UpdatePostUseCase: Sendable {
    func execute(courseId: String, postId: String, request: UpdatePostRequest) async throws -> Post
}
