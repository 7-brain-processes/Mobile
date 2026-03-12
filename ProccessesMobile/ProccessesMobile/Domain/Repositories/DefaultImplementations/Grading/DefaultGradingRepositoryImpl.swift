//
//  DefaultGradingRepositoryImpl.swift
//  ProccessesMobile
//
//  Created by dark type on 06.03.2026.
//

import Foundation

struct DefaultGradingRepositoryImpl: GradingRepository {

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

    func gradeSolution(_ command: GradeSolutionCommand) async throws -> Solution {

        let req = try GradingEndpoint.grade(
            courseId: command.courseId.uuidString,
            postId: command.postId.uuidString,
            solutionId: command.solutionId.uuidString,
            request: GradeSolutionMapper.toDTO(command),
            baseURL: baseURL
        ).makeURLRequest()

        let (data, res) = try await client.send(req)

        try validate(res, success: 200)

        let dto = try decoder.decode(SolutionDTO.self, from: data)

        return try SolutionMapper.toDomain(dto)
    }
}
