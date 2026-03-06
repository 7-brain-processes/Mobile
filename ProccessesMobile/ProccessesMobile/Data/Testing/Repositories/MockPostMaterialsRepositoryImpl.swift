//
//  MockPostMaterialsRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockPostMaterialsRepositoryImpl: PostMaterialsRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    public init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }
    
    public func listMaterials(courseId: String, postId: String) async throws -> [AttachedFile] {
        let req = try PostMaterialsEndpoint.list(courseId: courseId, postId: postId, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        
        return try JSONDecoder().decode([AttachedFile].self, from: data)
    }
    
    public func deleteMaterial(courseId: String, postId: String, fileId: String) async throws {
        let req = try PostMaterialsEndpoint.delete(courseId: courseId, postId: postId, fileId: fileId, baseURL: baseURL).makeURLRequest()
        let (_, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 204 || res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
    }
    
    public func downloadMaterial(courseId: String, postId: String, fileId: String) async throws -> Data {
        let req = try PostMaterialsEndpoint.download(courseId: courseId, postId: postId, fileId: fileId, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        
        return data
    }
    
    public func uploadMaterial(courseId: String, postId: String, request: UploadFileRequest) async throws -> AttachedFile {
        let req = try PostMaterialsEndpoint.upload(courseId: courseId, postId: postId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        if res.statusCode == 413 { throw APIError.serverError(code: 413) } // File too large!
        guard res.statusCode == 201 else { throw APIError.serverError(code: res.statusCode) }
        
        return try JSONDecoder().decode(AttachedFile.self, from: data)
    }
}
