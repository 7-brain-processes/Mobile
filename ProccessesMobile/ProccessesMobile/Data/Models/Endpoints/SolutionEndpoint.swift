//
//  SolutionEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum SolutionEndpoint {
    case list(courseId: String, postId: String, page: Int, size: Int, status: SolutionStatus?, baseURL: URL)
    case submit(courseId: String, postId: String, request: CreateSolutionRequest, baseURL: URL)
    case getMy(courseId: String, postId: String, baseURL: URL)
    case get(courseId: String, postId: String, solutionId: String, baseURL: URL)
    case update(courseId: String, postId: String, solutionId: String, request: CreateSolutionRequest, baseURL: URL)
    case delete(courseId: String, postId: String, solutionId: String, baseURL: URL)
    
    func makeURLRequest() throws -> URLRequest {
        let basePath = "/courses"
        switch self {
        case let .list(courseId, postId, page, size, status, baseURL):
            var components = URLComponents(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/posts/\(postId)/solutions"), resolvingAgainstBaseURL: false)!
            var items = [URLQueryItem(name: "page", value: String(page)), URLQueryItem(name: "size", value: String(size))]
            if let status = status { items.append(URLQueryItem(name: "status", value: status.rawValue)) }
            components.queryItems = items
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            return request
            
        case let .submit(courseId, postId, dto, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/posts/\(postId)/solutions"))
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            return request
            
        case let .getMy(courseId, postId, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/posts/\(postId)/solutions/my"))
            request.httpMethod = "GET"
            return request
            
        case let .get(courseId, postId, solutionId, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/posts/\(postId)/solutions/\(solutionId)"))
            request.httpMethod = "GET"
            return request
            
        case let .update(courseId, postId, solutionId, dto, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/posts/\(postId)/solutions/\(solutionId)"))
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            return request
            
        case let .delete(courseId, postId, solutionId, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("\(basePath)/\(courseId)/posts/\(postId)/solutions/\(solutionId)"))
            request.httpMethod = "DELETE"
            return request
        }
    }
}
