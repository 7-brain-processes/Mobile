//
//  PostEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public enum PostEndpoint {
    case list(courseId: String, page: Int, size: Int, type: PostType?, baseURL: URL)
    case create(courseId: String, request: CreatePostRequest, baseURL: URL)
    case get(courseId: String, postId: String, baseURL: URL)
    case update(courseId: String, postId: String, request: UpdatePostRequest, baseURL: URL)
    case delete(courseId: String, postId: String, baseURL: URL)
    
    public func makeURLRequest() throws -> URLRequest {
        switch self {
        case let .list(courseId, page, size, type, baseURL):
            var components = URLComponents(url: baseURL.appendingPathComponent("/courses/\(courseId)/posts"), resolvingAgainstBaseURL: false)!
            var items = [URLQueryItem(name: "page", value: String(page)), URLQueryItem(name: "size", value: String(size))]
            if let type = type { items.append(URLQueryItem(name: "type", value: type.rawValue)) }
            components.queryItems = items
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            return request
            
        case let .create(courseId, dto, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("/courses/\(courseId)/posts"))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            return request
            
        case let .get(courseId, postId, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("/courses/\(courseId)/posts/\(postId)"))
            request.httpMethod = "GET"
            return request
            
        case let .update(courseId, postId, dto, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("/courses/\(courseId)/posts/\(postId)"))
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            return request
            
        case let .delete(courseId, postId, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("/courses/\(courseId)/posts/\(postId)"))
            request.httpMethod = "DELETE"
            return request
        }
    }
}
