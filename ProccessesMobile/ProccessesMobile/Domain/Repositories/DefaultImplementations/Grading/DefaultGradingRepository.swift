//
//  DefaultGradingRepository.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultGradingRepository: GradingRepository, Sendable {

    private let apiClient: APIClient
    private let decoder: JSONDecoder

    init(
        apiClient: APIClient,
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.apiClient = apiClient
        self.decoder = decoder
    }

    func gradeSolution(_ command: GradeSolutionCommand) async throws -> Solution {

        let endpoint = GradingEndpoint.grade(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            request: GradeSolutionMapper.toDTO(command)
        )

        let (data, response) = try await apiClient.send(endpoint)

        try ResponseValidator.validate(response, successCodes: [200])

        let dto = try decoder.decode(SolutionDTO.self, from: data)

        return try SolutionMapper.toDomain(dto)
    }
}
