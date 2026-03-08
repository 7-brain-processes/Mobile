//
//  GradingEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum GradingEndpoint {
    case grade(courseId: String, postId: String, solutionId: String, request: GradeRequest, baseURL: URL)
    
    func makeURLRequest() throws -> URLRequest {
        switch self {
        case let .grade(courseId, postId, solutionId, dto, baseURL):
            let path = "/courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/grade"
            var request = URLRequest(url: baseURL.appendingPathComponent(path))
            request.httpMethod = "PUT"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = try JSONEncoder().encode(dto)
            return request
        }
    }
}
