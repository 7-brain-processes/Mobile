//
//  MockCourseInvitesRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Foundation

struct MockCourseInvitesRepositoryImpl: CourseInvitesRepository {
    private let client: HTTPClient
    private let baseURL: URL
    
    init(client: HTTPClient, baseURL: URL) { self.client = client; self.baseURL = baseURL }
    
    func listInvites(courseId: String) async throws -> [Invite] {
        let req = try CourseInvitesEndpoint.list(courseId: courseId, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        guard res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
        return try JSONDecoder().decode([Invite].self, from: data)
    }
    
    func createInvite(courseId: String, request: CreateInviteRequest) async throws -> Invite {
        let req = try CourseInvitesEndpoint.create(courseId: courseId, request: request, baseURL: baseURL).makeURLRequest()
        let (data, res) = try await client.send(req)
        guard res.statusCode == 201 else { throw APIError.serverError(code: res.statusCode) }
        return try JSONDecoder().decode(Invite.self, from: data)
    }
    
    func revokeInvite(courseId: String, inviteId: String) async throws {
        let req = try CourseInvitesEndpoint.revoke(courseId: courseId, inviteId: inviteId, baseURL: baseURL).makeURLRequest()
        let (_, res) = try await client.send(req)
        guard res.statusCode == 204 || res.statusCode == 200 else { throw APIError.serverError(code: res.statusCode) }
    }
}
