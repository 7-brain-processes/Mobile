//
//  PostCommentsEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum PostCommentsEndpoint {
    case list(courseId: String, postId: String, page: Int, size: Int, baseURL: URL)
    case create(courseId: String, postId: String, request: CreateCommentRequestDTO, baseURL: URL)
    case update(courseId: String, postId: String, commentId: String, request: CreateCommentRequestDTO, baseURL: URL)
    case delete(courseId: String, postId: String, commentId: String, baseURL: URL)
    
    func makeURLRequest() throws -> URLRequest {
        let basePath = "/courses"
        switch self {
        case let .list(courseId, postId, page, size, baseURL):
            var components = URLComponents(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/posts/\(postId)/comments"), resolvingAgainstBaseURL: false)!
            components.queryItems = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "size", value: String(size))
            ]
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            return request
            
        case let .create(courseId, postId, dto, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/posts/\(postId)/comments"))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            return request
            
        case let .update(courseId, postId, commentId, dto, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/posts/\(postId)/comments/\(commentId)"))
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            return request
            
        case let .delete(courseId, postId, commentId, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/posts/\(postId)/comments/\(commentId)"))
            request.httpMethod = "DELETE"
            return request
        }
    }
}
