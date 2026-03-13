//
//  DefaultCourseRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultCourseRepository: CourseRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func getMyCourses(_ query: GetMyCoursesQuery) async throws -> Page<Course> {

        let endpoint = CourseEndpoint.getCourses(
            page: query.page,
            size: query.size,
            role: query.role.map(CourseRoleMapper.toDTO)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(PageDTO<CourseDTO>.self, from: data)

        return try PageMapper.toDomain(
            dto,
            itemMapper: CourseMapper.toDomain
        )
    }

    func createCourse(_ command: CreateCourseCommand) async throws -> Course {

        let endpoint = CourseEndpoint.create(
            request: CreateCourseMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [201])

        let dto = try decoder.decode(CourseDTO.self, from: data)

        return try CourseMapper.toDomain(dto)
    }
}
