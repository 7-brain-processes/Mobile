//
//  DefaultCourseInvitesRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//


import Foundation

struct DefaultCourseInvitesRepository: CourseInvitesRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func listInvites(courseId: UUID) async throws -> [Invite] {

        let endpoint = CourseInvitesEndpoint.list(
            courseId: courseId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode([InviteDTO].self, from: data)

        return try dto.map(InviteMapper.toDomain)
    }

    func createInvite(_ command: CreateInviteCommand) async throws -> Invite {

        let endpoint = CourseInvitesEndpoint.create(
            courseId: command.courseId.uuidString,
            request: CreateInviteMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [201])

        let dto = try decoder.decode(InviteDTO.self, from: data)

        return try InviteMapper.toDomain(dto)
    }

    func revokeInvite(_ command: RevokeInviteCommand) async throws {

        let endpoint = CourseInvitesEndpoint.revoke(
            courseId: command.courseId.uuidString,
            inviteId: command.inviteId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 204])
    }
}
