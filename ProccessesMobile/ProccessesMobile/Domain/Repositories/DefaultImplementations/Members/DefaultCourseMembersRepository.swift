//
//  DefaultCourseMembersRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultCourseMembersRepository: CourseMembersRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func listMembers(_ query: ListMembersQuery) async throws -> Page<Member> {

        let endpoint = CourseMembersEndpoint.list(
            courseId: query.courseId.uuidString,
            page: query.page,
            size: query.size,
            role: query.role.map(CourseRoleMapper.toDTO)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(PageDTO<MemberDTO>.self, from: data)

        return try PageMapper.toDomain(
            dto,
            itemMapper: MemberMapper.toDomain
        )
    }

    func removeMember(_ command: RemoveMemberCommand) async throws {

        let endpoint = CourseMembersEndpoint.remove(
            courseId: command.courseId.uuidString,
            userId: command.userId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 204])
    }
}
