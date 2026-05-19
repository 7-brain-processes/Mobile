//
//  PostTeamsEndpoint.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

enum PostTeamsEndpoint: Endpoint {
    case listForEnrollment(courseId: String, postId: String)
    case getMyTeam(courseId: String, postId: String)
    case enroll(courseId: String, postId: String, teamId: String)
    case leave(courseId: String, postId: String, teamId: String)

    var path: String {
        switch self {
        case .listForEnrollment(let courseId, let postId):
            return "courses/\(courseId)/posts/\(postId)/teams"

        case .getMyTeam(let courseId, let postId):
            return "courses/\(courseId)/posts/\(postId)/my-team"

        case .enroll(let courseId, let postId, let teamId):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/enroll"

        case .leave(let courseId, let postId, let teamId):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/leave"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listForEnrollment, .getMyTeam:
            return .GET
        case .enroll:
            return .POST
        case .leave:
            return .DELETE
        }
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