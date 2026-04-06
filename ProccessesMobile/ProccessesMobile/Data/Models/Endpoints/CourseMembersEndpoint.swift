//
//  CourseMembersEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseMembersEndpoint: Endpoint {
    case list(courseId: String, page: Int, size: Int, role: CourseRoleDTO?)
    case remove(courseId: String, userId: String)

    var path: String {
        switch self {
        case .list(let courseId, _, _, _):
            return "courses/\(courseId)/members"
        case .remove(let courseId, let userId):
            return "courses/\(courseId)/members/\(userId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return .GET
        case .remove:
            return .DELETE
        }
    }

    var headers: [String: String] {
        [
            "Accept": "application/json"
        ]
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .list(_, let page, let size, let role):
            var items = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "size", value: String(size))
            ]

            if let role {
                items.append(URLQueryItem(name: "role", value: role.rawValue))
            }

            return items

        case .remove:
            return []
        }
    }

    var body: EndpointBody {
        switch self {
        case .list, .remove:
            return .none
        }
    }

    var requiresAuth: Bool {
        true
    }
}
