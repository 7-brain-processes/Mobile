//
//  CourseMembersEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseMembersEndpoint {
    case list(courseId: String, page: Int, size: Int, role: CourseRole?, baseURL: URL)
    case remove(courseId: String, userId: String, baseURL: URL)
    
    func makeURLRequest() throws -> URLRequest {
        switch self {
        case let .list(courseId, page, size, role, baseURL):
            var components = URLComponents(url: baseURL.appendingPathComponent("/courses/\(courseId)/members"), resolvingAgainstBaseURL: false)!
            var items = [URLQueryItem(name: "page", value: String(page)), URLQueryItem(name: "size", value: String(size))]
            if let role = role { items.append(URLQueryItem(name: "role", value: role.rawValue)) }
            components.queryItems = items
            
            var request = URLRequest(url: components.url!)
            request.httpMethod = "GET"
            return request
            
        case let .remove(courseId, userId, baseURL):
            var request = URLRequest(url: baseURL.appendingPathComponent("/courses/\(courseId)/members/\(userId)"))
            request.httpMethod = "DELETE"
            return request
        }
    }
}
