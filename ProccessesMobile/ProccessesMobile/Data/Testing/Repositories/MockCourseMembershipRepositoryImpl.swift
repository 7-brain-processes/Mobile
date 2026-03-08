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

    func joinCourse(_ command: JoinCourseCodeCommand) async throws -> Course {

        let request = try CourseMembershipEndpoint
            .join(code: command.code, baseURL: baseURL)
            .makeURLRequest()

        let (data, response) = try await client.send(request)

        try validate(response, success: 200)

        let dto = try JSONDecoder().decode(CourseDTO.self, from: data)
        return try dto.toDomain()
    }

    func leaveCourse(_ command: LeaveCourseCommand) async throws {

        let request = try CourseMembershipEndpoint
            .leave(courseId: command.courseId.uuidString, baseURL: baseURL)
            .makeURLRequest()

        let (_, response) = try await client.send(request)

        if response.statusCode == 200 || response.statusCode == 204 {
            return
        }

        try validate(response, success: 200)
    }
}
