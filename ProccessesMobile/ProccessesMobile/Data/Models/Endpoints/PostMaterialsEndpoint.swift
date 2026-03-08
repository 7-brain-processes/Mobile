//
//  PostMaterialsEndpoint.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

enum PostMaterialsEndpoint {
    case upload(courseId: String, postId: String, request: UploadFileRequestDTO, baseURL: URL)
    case list(courseId: String, postId: String, baseURL: URL)
    case delete(courseId: String, postId: String, fileId: String, baseURL: URL)
    case download(courseId: String, postId: String, fileId: String, baseURL: URL)
    
    func makeURLRequest() throws -> URLRequest {
        switch self {
        case let .upload(courseId, postId, dto, baseURL):
            let basePath = "/courses/\(courseId)/posts/\(postId)/materials"
            let url = baseURL.appendingPathComponent(basePath)
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            let boundary = UUID().uuidString
            request.setMultipartFormData(boundary: boundary, name: "file", fileName: dto.fileName, mimeType: dto.mimeType, data: dto.data)
            return request
            
        case let .list(courseId, postId, baseURL):
            let basePath = "/courses/\(courseId)/posts/\(postId)/materials"
            let url = baseURL.appendingPathComponent(basePath)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
            
        case let .delete(courseId, postId, fileId, baseURL):
            let path = "/courses/\(courseId)/posts/\(postId)/materials/\(fileId)"
            let url = baseURL.appendingPathComponent(path)
            var request = URLRequest(url: url)
            request.httpMethod = "DELETE"
            return request
            
        case let .download(courseId, postId, fileId, baseURL):
            let path = "/courses/\(courseId)/posts/\(postId)/materials/\(fileId)/download"
            let url = baseURL.appendingPathComponent(path)
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            return request
        }
    }
}
extension URLRequest {
    mutating func setMultipartFormData(boundary: String, name: String, fileName: String, mimeType: String, data: Data) {
        self.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"\(name)\"; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(data)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        self.httpBody = body
    }
}
