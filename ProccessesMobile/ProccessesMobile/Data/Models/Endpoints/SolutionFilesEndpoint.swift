//
//  SolutionFilesEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum SolutionFilesEndpoint: Endpoint {
    case upload(courseId: String, postId: String, solutionId: String, request: UploadFileRequestDTO)
    case list(courseId: String, postId: String, solutionId: String)
    case delete(courseId: String, postId: String, solutionId: String, fileId: String)
    case download(courseId: String, postId: String, solutionId: String, fileId: String)

    var path: String {
        switch self {
        case .upload(let courseId, let postId, let solutionId, _),
             .list(let courseId, let postId, let solutionId):
            return "courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/files"

        case .delete(let courseId, let postId, let solutionId, let fileId):
            return "courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/files/\(fileId)"

        case .download(let courseId, let postId, let solutionId, let fileId):
            return "courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/files/\(fileId)/download"
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
        case .list, .delete:
            return ["Accept": "application/json"]
        case .upload, .download:
            return [:]
        }
    }

    var queryItems: [URLQueryItem] {
        []
    }

    var body: EndpointBody {
        switch self {
        case .list, .delete, .download:
            return .none

        case .upload(_, _, _, let request):
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
