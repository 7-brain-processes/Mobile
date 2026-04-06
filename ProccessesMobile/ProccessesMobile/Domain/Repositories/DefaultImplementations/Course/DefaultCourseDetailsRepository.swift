//
//  DefaultCourseDetailsRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultCourseDetailsRepository: CourseDetailsRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func getCourse(_ query: GetCourseQuery) async throws -> Course {

        let endpoint = CourseDetailsEndpoint.get(
            courseId: query.courseId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(CourseDTO.self, from: data)

        return try CourseMapper.toDomain(dto)
    }

    func updateCourse(_ command: UpdateCourseCommand) async throws -> Course {

        let endpoint = CourseDetailsEndpoint.update(
            courseId: command.courseId.uuidString,
            request: UpdateCourseMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(CourseDTO.self, from: data)

        return try CourseMapper.toDomain(dto)
    }

    func deleteCourse(_ query: DeleteCourseQuery) async throws {

        let endpoint = CourseDetailsEndpoint.delete(
            courseId: query.courseId.uuidString
        )

        let (_, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200, 204])
    }
}
