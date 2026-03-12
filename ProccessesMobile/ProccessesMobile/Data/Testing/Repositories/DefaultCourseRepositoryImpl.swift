//
//  DefaultCourseRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultCourseRepositoryImpl: CourseRepository {

    private let client: HTTPClient
    private let baseURL: URL

    init(client: HTTPClient, baseURL: URL) {
        self.client = client
        self.baseURL = baseURL
    }

    private var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    func getMyCourses(_ query: GetMyCoursesQuery) async throws -> Page<Course> {

        let request = try CourseEndpoint
            .getCourses(
                page: query.page,
                size: query.size,
                role: query.role?.toDTO(),
                baseURL: baseURL
            )
            .makeURLRequest()

        let (data, response) = try await client.send(request)

        try validate(response, success: 200)

        let dto = try decoder.decode(PageCourseDTO.self, from: data)

        return try dto.toDomain { try $0.toDomain() }
    }

    func createCourse(_ command: CreateCourseCommand) async throws -> Course {

        let urlRequest = try CourseEndpoint
            .create(
                request: command.toDTO(),
                baseURL: baseURL
            )
            .makeURLRequest()

        let (data, response) = try await client.send(urlRequest)

        if response.statusCode == 401 { throw APIError.unauthorized }

        guard response.statusCode == 201 else {
            throw APIError.serverError(code: response.statusCode)
        }

        let dto = try decoder.decode(CourseDTO.self, from: data)

        return try dto.toDomain()
    }
}
