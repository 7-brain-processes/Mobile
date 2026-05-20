//
//  PostTeamsEndpoint.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 19.05.2026.
//


import Foundation

enum PostTeamsEndpoint: Endpoint {
    case listForEnrollment(courseId: String, postId: String)
    case create(courseId: String, postId: String, request: CreatePostTeamRequestDTO)
    case grade(courseId: String, postId: String, teamId: String, request: TeamGradeRequestDTO)
    case getMyTeam(courseId: String, postId: String)
    case enroll(courseId: String, postId: String, teamId: String)
    case leave(courseId: String, postId: String, teamId: String)
    case getGrade(courseId: String, postId: String, teamId: String)

    var path: String {
        switch self {
        case .listForEnrollment(let courseId, let postId),
             .create(let courseId, let postId, _):
            return "courses/\(courseId)/posts/\(postId)/teams"

        case .getMyTeam(let courseId, let postId):
            return "courses/\(courseId)/posts/\(postId)/my-team"

        case .grade(let courseId, let postId, let teamId, _),
             .getGrade(let courseId, let postId, let teamId):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/grade"

        case .enroll(let courseId, let postId, let teamId):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/enroll"

        case .leave(let courseId, let postId, let teamId):
            return "courses/\(courseId)/posts/\(postId)/teams/\(teamId)/leave"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .listForEnrollment, .getMyTeam, .getGrade:
            return .GET
        case .create, .enroll:
            return .POST
        case .grade:
            return .PUT
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
        switch self {
        case .listForEnrollment, .getMyTeam, .enroll, .leave, .getGrade:
            return .none
        case .create(_, _, let request):
            return .json(request)
        case .grade(_, _, _, let request):
            return .json(request)
            
        }
    }

    var requiresAuth: Bool {
        true
    }
}
