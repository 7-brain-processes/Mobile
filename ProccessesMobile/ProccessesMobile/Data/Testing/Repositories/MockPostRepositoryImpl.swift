//
//  MockPostRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockPostRepositoryImpl: PostRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }
    
    private func handleResponse<T: Decodable>(data: Data, response: HTTPURLResponse, successCodes: [Int]) throws -> T {
        if response.statusCode == 401 { throw APIError.unauthorized }
        if response.statusCode == 403 { throw APIError.serverError(code: 403) }
        if response.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard successCodes.contains(response.statusCode) else { throw APIError.serverError(code: response.statusCode) }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func listPosts(courseId: String, page: Int, size: Int, type: PostType?) async throws -> PagePost {
        let req = try PostEndpoint.list(courseId: courseId, page: page, size: size, type: type, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        return try handleResponse(data: data, response: res, successCodes: [200])
    }
    
    func createPost(courseId: String, request: CreatePostRequest) async throws -> Post {
        let req = try PostEndpoint.create(courseId: courseId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        return try handleResponse(data: data, response: res, successCodes: [201])
    }
    
    func getPost(courseId: String, postId: String) async throws -> Post {
        let req = try PostEndpoint.get(courseId: courseId, postId: postId, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        return try handleResponse(data: data, response: res, successCodes: [200])
    }
    
    func updatePost(courseId: String, postId: String, request: UpdatePostRequest) async throws -> Post {
        let req = try PostEndpoint.update(courseId: courseId, postId: postId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        return try handleResponse(data: data, response: res, successCodes: [200])
    }
    
    func deletePost(courseId: String, postId: String) async throws {
        let req = try PostEndpoint.delete(courseId: courseId, postId: postId, baseURL: baseURL).makeURLRequest()
        let (_, res) = try await client.send(req)
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 204 || res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
    }
}
