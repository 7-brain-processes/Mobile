//
//  MockCourseMembershipRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockCourseMembershipRepositoryImpl: CourseMembershipRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }
    
    func joinCourse(code: String) async throws -> Course {
        let request = try CourseMembershipEndpoint.join(code: code, baseURL: baseURL).makeURLRequest()
        let (data, response) = try await client.send(request)
        
        if response.statusCode == 401 { throw APIError.unauthorized }
        if response.statusCode == 404 { throw APIError.serverError(code: 404) }
        if response.statusCode == 409 { throw APIError.serverError(code: 409) } 
        
        guard response.statusCode == 200 else {
            throw APIError.serverError(code: response.statusCode)
        }
        
        return try JSONDecoder().decode(Course.self, from: data)
    }
    
    func leaveCourse(courseId: String) async throws {
        let request = try CourseMembershipEndpoint.leave(courseId: courseId, baseURL: baseURL).makeURLRequest()
        let (_, response) = try await client.send(request)
        
        if response.statusCode == 401 { throw APIError.unauthorized }
        if response.statusCode == 403 { throw APIError.serverError(code: 403) }
        if response.statusCode == 404 { throw APIError.serverError(code: 404) }
        
        guard response.statusCode == 200 || response.statusCode == 204 else {
            throw APIError.serverError(code: response.statusCode)
        }
    }
}
