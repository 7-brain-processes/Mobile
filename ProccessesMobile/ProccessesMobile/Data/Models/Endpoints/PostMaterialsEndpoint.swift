//
//  PostMaterialsEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum PostMaterialsEndpoint: Endpoint {
    case upload(courseId: String, postId: String, request: UploadFileRequestDTO)
    case list(courseId: String, postId: String)
    case delete(courseId: String, postId: String, fileId: String)
    case download(courseId: String, postId: String, fileId: String)

    var path: String {
        switch self {
        case .upload(let courseId, let postId, _),
             .list(let courseId, let postId):
            return "courses/\(courseId)/posts/\(postId)/materials"

        case .delete(let courseId, let postId, let fileId):
            return "courses/\(courseId)/posts/\(postId)/materials/\(fileId)"

        case .download(let courseId, let postId, let fileId):
            return "courses/\(courseId)/posts/\(postId)/materials/\(fileId)/download"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .upload:
            return .POST
        case .list, .download:
            return .GET
        case .delete:
            return .DELETE
        }
    }

    var headers: [String: String] {
        switch self {
        case .upload:
            return [:]
        case .list, .delete, .download:
            return ["Accept": "application/json"]
        }
    }

    var queryItems: [URLQueryItem] {
        []
    }

    var body: EndpointBody {
        switch self {
        case .list, .delete, .download:
            return .none

        case .upload(_, _, let request):
            let boundary = UUID().uuidString
            let body = MultipartFormDataBuilder.makeFileBody(
                fieldName: "file",
                fileName: request.fileName,
                mimeType: request.mimeType,
                data: request.data,
                boundary: boundary
            )

            return .raw(
                body,
                contentType: MultipartFormDataBuilder.contentType(boundary: boundary)
            )
        }
    }

    var requiresAuth: Bool {
        true
    }
}
