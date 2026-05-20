//
//  TeamRequirementTemplateEndpoint.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 14.05.2026.
//


import Foundation

enum TeamRequirementTemplateEndpoint: Endpoint {
    case list(courseId: String)
    case create(courseId: String, request: CreateTeamRequirementTemplateRequestDTO)

    var path: String {
        switch self {
        case .list(let courseId),
             .create(let courseId, _):
            return "courses/\(courseId)/team-requirement-templates"
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

    var requiresAuth: Bool {
        true
    }
}