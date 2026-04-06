//
//  CourseInvitesEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum CourseInvitesEndpoint: Endpoint {
    case list(courseId: String)
    case create(courseId: String, request: CreateInviteRequestDTO)
    case revoke(courseId: String, inviteId: String)

    var path: String {
        switch self {
        case .list(let courseId),
             .create(let courseId, _):
            return "courses/\(courseId)/invites"

        case .revoke(let courseId, let inviteId):
            return "courses/\(courseId)/invites/\(inviteId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
            return .GET
        case .create:
            return .POST
        case .revoke:
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
        case .list, .revoke:
            return .none
        case .create(_, let request):
            return .json(request)
        }
    }

    var requiresAuth: Bool {
        true
    }
}
