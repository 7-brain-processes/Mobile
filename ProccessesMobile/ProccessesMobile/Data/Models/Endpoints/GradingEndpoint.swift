//
//  GradingEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum GradingEndpoint: Endpoint {
    case grade(
        courseId: String,
        postId: String,
        solutionId: String,
        request: GradeRequestDTO
    )

    var path: String {
        switch self {
        case .grade(let courseId, let postId, let solutionId, _):
            return "courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/grade"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .grade:
            return .PUT
        }
    }

    var headers: [String: String] {
        [
            "Accept": "application/json"
        ]
    }

    var queryItems: [URLQueryItem] {
        []
    }

    var body: EndpointBody {
        switch self {
        case .grade(_, _, _, let request):
            return .json(request)
        }
    }

    var requiresAuth: Bool {
        true
    }
}
