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
    case removeGrade(
        courseId: String,
        postId: String,
        solutionId: String
    )

    var path: String {
        switch self {
        case .grade(let courseId, let postId, let solutionId, _),
             .removeGrade(let courseId, let postId, let solutionId):
            return "courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/grade"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .grade:
            return .PUT
        case .removeGrade:
            return .DELETE
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
        case .removeGrade:
            return .none
        }
    }

    var requiresAuth: Bool {
        true
    }
}
