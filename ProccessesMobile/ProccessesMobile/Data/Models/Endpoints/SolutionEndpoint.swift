//
//  SolutionEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum SolutionEndpoint: Endpoint {
    case list(courseId: String, postId: String, page: Int, size: Int, status: SolutionStatusDTO?)
    case submit(courseId: String, postId: String, request: CreateSolutionRequestDTO)
    case getMy(courseId: String, postId: String)
    case get(courseId: String, postId: String, solutionId: String)
    case update(courseId: String, postId: String, solutionId: String, request: CreateSolutionRequestDTO)
    case delete(courseId: String, postId: String, solutionId: String)

    var path: String {
        switch self {
        case .list(let courseId, let postId, _, _, _),
             .submit(let courseId, let postId, _):
            return "courses/\(courseId)/posts/\(postId)/solutions"

        case .getMy(let courseId, let postId):
            return "courses/\(courseId)/posts/\(postId)/solutions/my"

        case .get(let courseId, let postId, let solutionId),
             .update(let courseId, let postId, let solutionId, _),
             .delete(let courseId, let postId, let solutionId):
            return "courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list, .getMy, .get:
            return .GET
        case .submit:
            return .POST
        case .update:
            return .PUT
        case .delete:
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
        case .list(_, _, let page, let size, let status):
            var items = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "size", value: String(size))
            ]

            if let status {
                items.append(URLQueryItem(name: "status", value: status.rawValue))
            }

            return items

        case .submit, .getMy, .get, .update, .delete:
            return []
        }
    }

    var body: EndpointBody {
        switch self {
        case .list, .getMy, .get, .delete:
            return .none

        case .submit(_, _, let request),
             .update(_, _, _, let request):
            return .json(request)
        }
    }

    var requiresAuth: Bool {
        true
    }
}
