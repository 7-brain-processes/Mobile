//
//  SolutionFilesEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum SolutionFilesEndpoint {
    case upload(courseId: String, postId: String, solutionId: String, request: UploadFileRequest, baseURL: URL)
    case list(courseId: String, postId: String, solutionId: String, baseURL: URL)
    case delete(courseId: String, postId: String, solutionId: String, fileId: String, baseURL: URL)
    case download(courseId: String, postId: String, solutionId: String, fileId: String, baseURL: URL)
    
    func makeURLRequest() throws -> URLRequest {
        switch self {
        case let .upload(courseId, postId, solutionId, dto, baseURL):
            let basePath = "/courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/files"
            let url = baseURL.appendingPathComponent(basePath)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let boundary = UUID().uuidString
            request.setMultipartFormData(boundary: boundary, name: "file", fileName: dto.fileName, mimeType: dto.mimeType, data: dto.data)
            return request
            
        case let .list(courseId, postId, solutionId, baseURL):
            let basePath = "/courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/files"
            let url = baseURL.appendingPathComponent(basePath)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
            
        case let .delete(courseId, postId, solutionId, fileId, baseURL):
            let path = "/courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/files/\(fileId)"
            let url = baseURL.appendingPathComponent(path)
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            return request
            
        case let .download(courseId, postId, solutionId, fileId, baseURL):
            let path = "/courses/\(courseId)/posts/\(postId)/solutions/\(solutionId)/files/\(fileId)/download"
            let url = baseURL.appendingPathComponent(path)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }
    }
}
