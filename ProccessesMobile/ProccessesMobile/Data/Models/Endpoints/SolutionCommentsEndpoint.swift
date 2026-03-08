//
//  SolutionCommentsEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum SolutionCommentsEndpoint {
    case list(courseId: String, postId: String, solutionId: String, page: Int, size: Int, baseURL: URL)
    case create(courseId: String, postId: String, solutionId: String, request: CreateCommentRequestDTO, baseURL: URL)
    case update(courseId: String, postId: String, solutionId: String, commentId: String, request: CreateCommentRequestDTO, baseURL: URL)
    case delete(courseId: String, postId: String, solutionId: String, commentId: String, baseURL: URL)
    
    func makeURLRequest() throws -> URLRequest {
        switch self {
        case let .list(courseId, postId, solutionId, page, size, baseURL):
            let basePath = "/courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/comments"
            var components = URLComponents(url: baseURL.appendingPathComponent(basePath), resolvingAgainstBaseURL: false)!
            components.queryItems = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "size", value: String(size))
            ]
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            return request
            
        case let .create(courseId, postId, solutionId, dto, baseURL):
            let basePath = "/courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/comments"
            var request = URLRequest(url: baseURL.appendingPathComponent(basePath))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            return request
            
        case let .update(courseId, postId, solutionId, commentId, dto, baseURL):
            let path = "/courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/comments/\(commentId)"
            var request = URLRequest(url: baseURL.appendingPathComponent(path))
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            return request
            
        case let .delete(courseId, postId, solutionId, commentId, baseURL):
            let path = "/courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/comments/\(commentId)"
            var request = URLRequest(url: baseURL.appendingPathComponent(path))
            request.httpMethod = "DELETE"
            return request
        }
    }
}
