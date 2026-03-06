//
//  MockSolutionCommentsRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockSolutionCommentsRepositoryImpl: SolutionCommentsRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    public init(client: HTTPClient, baseURL: URL) { 
        self.client = client
        self.baseURL = baseURL 
    }
    
    public func listComments(courseId: String, postId: String, solutionId: String, page: Int, size: Int) async throws -> PageComment {
        let req = try SolutionCommentsEndpoint.list(courseId: courseId, postId: postId, solutionId: solutionId, page: page, size: size, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        
        return try JSONDecoder().decode(PageComment.self, from: data)
    }
    
    public func createComment(courseId: String, postId: String, solutionId: String, request: CreateCommentRequest) async throws -> Comment {
        let req = try SolutionCommentsEndpoint.create(courseId: courseId, postId: postId, solutionId: solutionId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        guard res.statusCode == 201 else { throw APIError.serverError(code: res.statusCode) }
        
        return try JSONDecoder().decode(Comment.self, from: data)
    }
    
    public func updateComment(courseId: String, postId: String, solutionId: String, commentId: String, request: CreateCommentRequest) async throws -> Comment {
        let req = try SolutionCommentsEndpoint.update(courseId: courseId, postId: postId, solutionId: solutionId, commentId: commentId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        
        return try JSONDecoder().decode(Comment.self, from: data)
    }
    
    public func deleteComment(courseId: String, postId: String, solutionId: String, commentId: String) async throws {
        let req = try SolutionCommentsEndpoint.delete(courseId: courseId, postId: postId, solutionId: solutionId, commentId: commentId, baseURL: baseURL).makeURLRequest()
        let (_, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        guard res.statusCode == 204 || res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
    }
}
