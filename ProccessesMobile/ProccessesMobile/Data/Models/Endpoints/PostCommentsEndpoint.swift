//
//  PostCommentsEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum PostCommentsEndpoint: Endpoint {
    case list(courseId: String, postId: String, page: Int, size: Int)
    case create(courseId: String, postId: String, request: CreateCommentRequestDTO)
    case update(courseId: String, postId: String, commentId: String, request: CreateCommentRequestDTO)
    case delete(courseId: String, postId: String, commentId: String)

    var path: String {
        switch self {
        case .list(let courseId, let postId, _, _),
             .create(let courseId, let postId, _):
            return "courses/\(courseId)/posts/\(postId)/comments"

        case .update(let courseId, let postId, let commentId, _),
             .delete(let courseId, let postId, let commentId):
            return "courses/\(courseId)/posts/\(postId)/comments/\(commentId)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .list:
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
        case .list(_, _, let page, let size):
            return [
                URLQueryItem(name: "page", value: String(page)),
                URLQueryItem(name: "size", value: String(size))
            ]

        case .create, .update, .delete:
            return []
        }
    }

    var body: EndpointBody {
        switch self {
        case .list, .delete:
            return .none

        case .create(_, _, let request),
             .update(_, _, _, let request):
            return .json(request)
        }
    }

    var requiresAuth: Bool {
        true
    }
}
