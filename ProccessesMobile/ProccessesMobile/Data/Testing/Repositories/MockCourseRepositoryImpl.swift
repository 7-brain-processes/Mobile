//
//  MockCourseRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct MockCourseRepositoryImpl: CourseRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }
    
    func getMyCourses(page: Int, size: Int, role: CourseRole?) async throws -> PageCourse {
        let request = try CourseEndpoint.getCourses(page: page, size: size, role: role, baseURL: baseURL).makeURLRequest()
        let (data, response) = try await client.send(request)
        
        if response.statusCode == 401 { throw APIError.unauthorized }
        guard response.statusCode == 200 else { throw APIError.serverError(code: response.statusCode) }
        
        return try JSONDecoder().decode(PageCourse.self, from: data)
    }
    
    func createCourse(request: CreateCourseRequest) async throws -> Course {
        let urlRequest = try CourseEndpoint.create(request: request, baseURL: baseURL).makeURLRequest()
        let (data, response) = try await client.send(urlRequest)
        
        if response.statusCode == 401 { throw APIError.unauthorized }
        guard response.statusCode == 201 else { throw APIError.serverError(code: response.statusCode) }
        
        return try JSONDecoder().decode(Course.self, from: data)
    }
}
