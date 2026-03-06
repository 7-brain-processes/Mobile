//
//  CreatePostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol CreatePostUseCase: Sendable {
    func execute(courseId: String, request: CreatePostRequest) async throws -> Post
}
