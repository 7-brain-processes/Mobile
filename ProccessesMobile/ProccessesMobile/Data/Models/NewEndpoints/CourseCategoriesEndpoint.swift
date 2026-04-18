//
//  CourseCategoriesEndpoint.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

enum CourseCategoriesEndpoint: Endpoint {
    case list(courseId: UUID)
    case create(courseId: UUID, request: CreateCourseCategoryRequestDTO)

    var path: String {
        switch self {
        case .list(let courseId):
            return "courses/\(courseId.uuidString)/categories"
        case .create(let courseId, _):
            return "courses/\(courseId.uuidString)/categories"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
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

    var body: EndpointBody {
        switch self {
        case .list:
            return .none
        case .create(_, let request):
            return .json(request)
        }
    }

    var requiresAuth: Bool { true }
}
