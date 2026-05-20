//
//  CourseTeamsEndpoint.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//


import Foundation

enum CourseTeamsEndpoint: Endpoint {
    case list(courseId: String)

    var path: String {
        switch self {
        case .list(let courseId):
            return "courses/\(courseId)/teams"
        }
    }

    var method: HTTPMethod {
        .GET
    }

    var headers: [String: String] {
        ["Accept": "application/json"]
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