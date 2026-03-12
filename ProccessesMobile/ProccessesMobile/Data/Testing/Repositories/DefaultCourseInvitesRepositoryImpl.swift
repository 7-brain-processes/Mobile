//
//  DefaultCourseInvitesRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Foundation

struct DefaultCourseInvitesRepositoryImpl: CourseInvitesRepository {

    private let client: HTTPClient
    private let baseURL: URL

    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }

    private let decoder: JSONDecoder = {
        let d = JSONDecoder()
        d.dateDecodingStrategy = .iso8601
        return d
    }()

    func listInvites(courseId: UUID) async throws -> [Invite] {

        let req = try CourseInvitesEndpoint
            .list(courseId: courseId.uuidString, baseURL: baseURL)
            .makeURLRequest()

        let (data, res) = try await client.send(req)

        guard res.statusCode == 200 else {
            throw APIError.serverError(code: res.statusCode)
        }

        let dto = try decoder.decode([InviteDTO].self, from: data)

        return try dto.map { try $0.toDomain() }
    }

    func createInvite(_ command: CreateInviteCommand) async throws -> Invite {

        let req = try CourseInvitesEndpoint
            .create(
                courseId: command.courseId.uuidString,
                request: command.toDTO(),
                baseURL: baseURL
            )
            .makeURLRequest()

        let (data, res) = try await client.send(req)

        guard res.statusCode == 201 else {
            throw APIError.serverError(code: res.statusCode)
        }

        let dto = try decoder.decode(InviteDTO.self, from: data)

        return try dto.toDomain()
    }

    func revokeInvite(_ command: RevokeInviteCommand) async throws {

        let req = try CourseInvitesEndpoint
            .revoke(
                courseId: command.courseId.uuidString,
                inviteId: command.inviteId.uuidString,
                baseURL: baseURL
            )
            .makeURLRequest()

        let (_, res) = try await client.send(req)

        guard res.statusCode == 204 || res.statusCode == 200 else {
            throw APIError.serverError(code: res.statusCode)
        }
    }
}
