//
//  MockGradingRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockGradingRepositoryImpl: GradingRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    public init(client: HTTPClient, baseURL: URL) { self.client = client; self.baseURL = baseURL }
    
    public func gradeSolution(courseId: String, postId: String, solutionId: String, request: GradeRequest) async throws -> Solution {
        let req = try GradingEndpoint.grade(courseId: courseId, postId: postId, solutionId: solutionId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        
        return try JSONDecoder().decode(Solution.self, from: data)
    }
}
