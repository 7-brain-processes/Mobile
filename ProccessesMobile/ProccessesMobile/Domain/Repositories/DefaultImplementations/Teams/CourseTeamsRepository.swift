//
//  CourseTeamsRepository.swift
//  ProccessesMobile
//
//  Created by Tark Wight on 20.05.2026.
//


import Foundation

protocol CourseTeamsRepository: Sendable {
    func listTeams(_ query: ListCourseTeamsQuery) async throws -> [CourseTeam]
}

struct DefaultCourseTeamsRepository: CourseTeamsRepository, Sendable {
    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func listTeams(_ query: ListCourseTeamsQuery) async throws -> [CourseTeam] {
        let endpoint = CourseTeamsEndpoint.list(
            courseId: query.courseId.uuidString
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode([CourseTeamDTO].self, from: data)

        return try dto.map(CourseTeamMapper.toDomain)
    }
}