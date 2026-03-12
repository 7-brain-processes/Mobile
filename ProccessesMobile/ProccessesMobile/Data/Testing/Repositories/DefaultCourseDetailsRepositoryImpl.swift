//
//  DefaultCourseDetailsRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultCourseDetailsRepository: CourseDetailsRepository {

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

    func getCourse(_ query: GetCourseQuery) async throws -> Course {

        let request = try CourseDetailsEndpoint
            .get(courseId: query.courseId.uuidString, baseURL: baseURL)
            .makeURLRequest()

        let (data, response) = try await client.send(request)

        if response.statusCode == 401 { throw APIError.unauthorized }
        try validate(response, success: 200)

        let dto = try decoder.decode(CourseDTO.self, from: data)
        return try dto.toDomain()
    }

    func updateCourse(_ command: UpdateCourseCommand) async throws -> Course {

        let request = try CourseDetailsEndpoint.update(
            courseId: command.courseId.uuidString,
            request: command.toDTO(),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, response) = try await client.send(request)

        if response.statusCode == 401 { throw APIError.unauthorized }
        try validate(response, success: 200)

        let dto = try decoder.decode(CourseDTO.self, from: data)

        return try dto.toDomain()
    }

    func deleteCourse(_ query: DeleteCourseQuery) async throws {

        let request = try CourseDetailsEndpoint
            .delete(courseId: query.courseId.uuidString, baseURL: baseURL)
            .makeURLRequest()

        let (_, response) = try await client.send(request)

        if response.statusCode == 401 { throw APIError.unauthorized }

        guard response.statusCode == 204 || response.statusCode == 200 else {
            throw APIError.serverError(code: response.statusCode)
        }
    }
}
