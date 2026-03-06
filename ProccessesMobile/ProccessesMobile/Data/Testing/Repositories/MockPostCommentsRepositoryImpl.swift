//
//  MockPostCommentsRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockPostCommentsRepositoryImpl: PostCommentsRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    public init(client: HTTPClient, baseURL: URL) { self.client = client; self.baseURL = baseURL }
    
    public func listComments(courseId: String, postId: String, page: Int, size: Int) async throws -> PageComment {
        let req = try PostCommentsEndpoint.list(courseId: courseId, postId: postId, page: page, size: size, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        return try JSONDecoder().decode(PageComment.self, from: data)
    }
    
    public func createComment(courseId: String, postId: String, request: CreateCommentRequest) async throws -> Comment {
        let req = try PostCommentsEndpoint.create(courseId: courseId, postId: postId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        guard res.statusCode == 201 else { throw APIError.serverError(code: res.statusCode) }
        return try JSONDecoder().decode(Comment.self, from: data)
    }
    
    public func updateComment(courseId: String, postId: String, commentId: String, request: CreateCommentRequest) async throws -> Comment {
        let req = try PostCommentsEndpoint.update(courseId: courseId, postId: postId, commentId: commentId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        return try JSONDecoder().decode(Comment.self, from: data)
    }
    
    public func deleteComment(courseId: String, postId: String, commentId: String) async throws {
        let req = try PostCommentsEndpoint.delete(courseId: courseId, postId: postId, commentId: commentId, baseURL: baseURL).makeURLRequest()
        let (_, res) = try await client.send(req)
        guard res.statusCode == 204 || res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
    }
}
