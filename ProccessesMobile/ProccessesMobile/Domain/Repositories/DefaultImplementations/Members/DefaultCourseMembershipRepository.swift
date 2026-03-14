//
//  DefaultCourseMembershipRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultCourseMembershipRepository: CourseMembershipRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func joinCourse(_ command: JoinCourseCodeCommand) async throws -> Course {

        let endpoint = CourseMembershipEndpoint.join(
            code: command.code
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(CourseDTO.self, from: data)

        return try CourseMapper.toDomain(dto)
    }

    func leaveCourse(_ command: LeaveCourseCommand) async throws {

        let endpoint = CourseMembershipEndpoint.leave(
            courseId: command.courseId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 204])
    }
}
