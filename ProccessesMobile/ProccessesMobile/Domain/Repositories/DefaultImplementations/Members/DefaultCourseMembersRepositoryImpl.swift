//
//  DefaultCourseMembersRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultCourseMembersRepositoryImpl: CourseMembersRepository {

    private let client: HTTPClient
    private let baseURL: URL

    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }

    func listMembers(_ query: ListMembersQuery) async throws -> Page<Member> {

        let req = try CourseMembersEndpoint
            .list(
                courseId: query.courseId.uuidString,
                page: query.page,
                size: query.size,
                role: query.role.map(CourseRoleMapper.toDTO),
                baseURL: baseURL
            )
            .makeURLRequest()

        let (data, res) = try await client.send(req)

        try validate(res, success: 200)

        let dto = try JSONDecoder().decode(PageDTO<MemberDTO>.self, from: data)

        return try PageMapper.toDomain(
            dto,
            itemMapper: MemberMapper.toDomain
        )
    }

    func removeMember(_ command: RemoveMemberCommand) async throws {

        let req = try CourseMembersEndpoint
            .remove(
                courseId: command.courseId.uuidString,
                userId: command.userId.uuidString,
                baseURL: baseURL
            )
            .makeURLRequest()

        let (_, res) = try await client.send(req)

        if res.statusCode == 200 || res.statusCode == 204 {
            return
        }

        try validate(res, success: 200)
    }
}
