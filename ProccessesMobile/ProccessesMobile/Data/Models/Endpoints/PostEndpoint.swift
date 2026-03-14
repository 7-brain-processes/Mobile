//
//  PostEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum PostEndpoint: Endpoint {
    case list(courseId: String, page: Int, size: Int, type: PostTypeDTO?)
    case create(courseId: String, request: CreatePostRequestDTO)
    case get(courseId: String, postId: String)
    case update(courseId: String, postId: String, request: UpdatePostRequestDTO)
    case delete(courseId: String, postId: String)

    var path: String {
        switch self {
        case .list(let courseId, _, _, _),
             .create(let courseId, _):
            return "courses/\(courseId)/posts"

        case .get(let courseId, let postId),
             .update(let courseId, let postId, _),
             .delete(let courseId, let postId):
            return "courses/\(courseId)/posts/\(postId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list, .get:
            return .GET
        case .create:
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
        case .list(_, let page, let size, let type):
            var items = [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "size", value: String(size))
            ]

            if let type {
                items.append(URLQueryItem(name: "type", value: type.rawValue))
            }

            return items

        case .create, .get, .update, .delete:
            return []
        }
    }

    var body: EndpointBody {
        switch self {
        case .list, .get, .delete:
            return .none

        case .create(_, let request):
            return .json(request)

        case .update(_, _, let request):
            return .json(request)
        }
    }

    var requiresAuth: Bool {
        true
    }
}
