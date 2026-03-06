//
//  GetPostUseCase.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


public protocol GetPostUseCase: Sendable {
    func execute(courseId: String, postId: String) async throws -> Post
}