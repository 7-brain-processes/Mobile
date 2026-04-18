//
//  CourseCategoriesEndpoint.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 18.04.2026.
//


import Foundation

enum CourseCategoriesEndpoint: Endpoint {
    case list(courseId: UUID)

    var path: String {
        switch self {
        case .list(let courseId):
            return "courses/\(courseId.uuidString)/categories"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return .GET
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
