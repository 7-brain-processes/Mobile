//
//  CourseDetailsEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseDetailsEndpoint: Endpoint {
    case get(courseId: String)
    case update(courseId: String, request: UpdateCourseRequestDTO)
    case delete(courseId: String)

    var path: String {
        switch self {
        case .get(let courseId),
             .update(let courseId, _),
             .delete(let courseId):
            return "courses/\(courseId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .get:
            return .GET
        case .update:
            return .PUT
        case .delete:
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
        case .get, .delete:
            return .none
        case .update(_, let request):
            return .json(request)
        }
    }

    var requiresAuth: Bool {
        true
    }
}
