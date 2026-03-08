//
//  MockSolutionFilesRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockSolutionFilesRepositoryImpl: SolutionFilesRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }
    
    func listSolutionFiles(courseId: String, postId: String, solutionId: String) async throws -> [AttachedFile] {
        let req = try SolutionFilesEndpoint.list(courseId: courseId, postId: postId, solutionId: solutionId, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        
        return try JSONDecoder().decode([AttachedFile].self, from: data)
    }
    
    func deleteSolutionFile(courseId: String, postId: String, solutionId: String, fileId: String) async throws {
        let req = try SolutionFilesEndpoint.delete(courseId: courseId, postId: postId, solutionId: solutionId, fileId: fileId, baseURL: baseURL).makeURLRequest()
        let (_, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 204 || res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
    }
    
    func downloadSolutionFile(courseId: String, postId: String, solutionId: String, fileId: String) async throws -> Data {
        let req = try SolutionFilesEndpoint.download(courseId: courseId, postId: postId, solutionId: solutionId, fileId: fileId, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        
        return data
    }
    
    func uploadSolutionFile(courseId: String, postId: String, solutionId: String, request: UploadFileRequest) async throws -> AttachedFile {
        let req = try SolutionFilesEndpoint.upload(courseId: courseId, postId: postId, solutionId: solutionId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 413 { throw APIError.serverError(code: 413) } 
        guard res.statusCode == 201 else { throw APIError.serverError(code: res.statusCode) }
        
        return try JSONDecoder().decode(AttachedFile.self, from: data)
    }
}
