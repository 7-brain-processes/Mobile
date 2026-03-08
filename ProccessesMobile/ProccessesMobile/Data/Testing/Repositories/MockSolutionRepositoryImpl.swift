//
//  MockSolutionRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockSolutionRepositoryImpl: SolutionRepository {
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
        if response.statusCode == 409 { throw APIError.serverError(code: 409) }
        
        guard successCodes.contains(response.statusCode) else { throw APIError.serverError(code: response.statusCode) }
        return try JSONDecoder().decode(T.self, from: data)
    }
    
    func listSolutions(courseId: String, postId: String, page: Int, size: Int, status: SolutionStatus?) async throws -> PageSolution {
        let req = try SolutionEndpoint.list(courseId: courseId, postId: postId, page: page, size: size, status: status, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        return try handleResponse(data: data, response: res, successCodes: [200])
    }
    
    func submitSolution(courseId: String, postId: String, request: CreateSolutionRequest) async throws -> Solution {
        let req = try SolutionEndpoint.submit(courseId: courseId, postId: postId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        return try handleResponse(data: data, response: res, successCodes: [201])
    }
    
    func getMySolution(courseId: String, postId: String) async throws -> Solution {
        let req = try SolutionEndpoint.getMy(courseId: courseId, postId: postId, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        return try handleResponse(data: data, response: res, successCodes: [200])
    }
    
    func getSolution(courseId: String, postId: String, solutionId: String) async throws -> Solution {
        let req = try SolutionEndpoint.get(courseId: courseId, postId: postId, solutionId: solutionId, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        return try handleResponse(data: data, response: res, successCodes: [200])
    }
    
    func updateSolution(courseId: String, postId: String, solutionId: String, request: CreateSolutionRequest) async throws -> Solution {
        let req = try SolutionEndpoint.update(courseId: courseId, postId: postId, solutionId: solutionId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        return try handleResponse(data: data, response: res, successCodes: [200])
    }
    
    func deleteSolution(courseId: String, postId: String, solutionId: String) async throws {
        let req = try SolutionEndpoint.delete(courseId: courseId, postId: postId, solutionId: solutionId, baseURL: baseURL).makeURLRequest()
        let (_, res) = try await client.send(req)
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 204 || res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
    }
}
