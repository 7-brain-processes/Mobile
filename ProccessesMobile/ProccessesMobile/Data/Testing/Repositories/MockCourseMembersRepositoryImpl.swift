//
//  MockCourseMembersRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

public struct MockCourseMembersRepositoryImpl: CourseMembersRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    public init(client: HTTPClient, baseURL: URL) { self.client = client; self.baseURL = baseURL }
    
    public func listMembers(courseId: String, page: Int, size: Int, role: CourseRole?) async throws -> PageMember {
        let req = try CourseMembersEndpoint.list(courseId: courseId, page: page, size: size, role: role, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        return try JSONDecoder().decode(PageMember.self, from: data)
    }
    
    public func removeMember(courseId: String, userId: String) async throws {
        let req = try CourseMembersEndpoint.remove(courseId: courseId, userId: userId, baseURL: baseURL).makeURLRequest()
        let (_, res) = try await client.send(req)
        
        if res.statusCode == 401 { throw APIError.unauthorized }
        if res.statusCode == 403 { throw APIError.serverError(code: 403) }
        if res.statusCode == 404 { throw APIError.serverError(code: 404) }
        guard res.statusCode == 204 || res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
    }
}
