//
//  CourseEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseEndpoint: Endpoint {
    case getCourses(page: Int, size: Int, role: CourseRoleDTO?)
    case create(request: CreateCourseRequestDTO)

    var path: String {
        switch self {
        case .getCourses, .create:
            return "courses"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .getCourses:
            return .GET
        case .create:
            return .POST
        }
    }

    var headers: [String: String] {
        [
            "Accept": "application/json"
        ]
    }

    var queryItems: [URLQueryItem] {
        switch self {
        case .getCourses(let page, let size, let role):
            var items = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "size", value: String(size))
            ]

            if let role {
                items.append(
                    URLQueryItem(name: "role", value: role.rawValue)
                )
            }

            return items

        case .create:
            return []
        }
    }

    var body: EndpointBody {
        switch self {
        case .getCourses:
            return .none
        case .create(let request):
            return .json(request)
        }
    }

    var requiresAuth: Bool {
        true
    }
}
