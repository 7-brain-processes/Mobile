//
//  MockCourseDetailsRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockCourseDetailsRepositoryImpl: CourseDetailsRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    public init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }
    
    public func getCourse(courseId: String) async throws -> Course {
        let request = try CourseDetailsEndpoint.get(courseId: courseId, baseURL: baseURL).makeURLRequest()
        let (data, response) = try await client.send(request)
        
        if response.statusCode == 401 { throw APIError.unauthorized }
        if response.statusCode == 403 { throw APIError.serverError(code: 403) }
        if response.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard response.statusCode == 200 else { throw APIError.serverError(code: response.statusCode) }
        
        return try JSONDecoder().decode(Course.self, from: data)
    }
    
    public func updateCourse(courseId: String, request: UpdateCourseRequest) async throws -> Course {
        let urlRequest = try CourseDetailsEndpoint.update(courseId: courseId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, response) = try await client.send(urlRequest)
        
        if response.statusCode == 401 { throw APIError.unauthorized }
        if response.statusCode == 403 { throw APIError.serverError(code: 403) }
        if response.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard response.statusCode == 200 else { throw APIError.serverError(code: response.statusCode) }
        
        return try JSONDecoder().decode(Course.self, from: data)
    }
    
    public func deleteCourse(courseId: String) async throws {
        let request = try CourseDetailsEndpoint.delete(courseId: courseId, baseURL: baseURL).makeURLRequest()
        let (_, response) = try await client.send(request)
        
        if response.statusCode == 401 { throw APIError.unauthorized }
        if response.statusCode == 403 { throw APIError.serverError(code: 403) }
        if response.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard response.statusCode == 204 || response.statusCode == 200 else { 
            throw APIError.serverError(code: response.statusCode) 
        }
    }
}
