//
//  CourseMembershipEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseMembershipEndpoint: Endpoint {
    case join(code: String)
    case leave(courseId: String)

    var path: String {
        switch self {
        case .join(let code):
            return "invites/\(code)/join"
        case .leave(let courseId):
            return "courses/\(courseId)/leave"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .join, .leave:
            return .POST
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
        .none
    }

    var requiresAuth: Bool {
        true
    }
}
