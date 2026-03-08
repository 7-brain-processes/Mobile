//
//  CourseMembershipEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseMembershipEndpoint {
    case join(code: String, baseURL: URL)
    case leave(courseId: String, baseURL: URL)
    
    func makeURLRequest() throws -> URLRequest {
        switch self {
        case let .join(code, baseURL):
            let url = baseURL.appendingPathComponent("/invites/\(code)/join")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            return request
            
        case let .leave(courseId, baseURL):
            let url = baseURL.appendingPathComponent("/courses/\(courseId)/leave")
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            return request
        }
    }
}
